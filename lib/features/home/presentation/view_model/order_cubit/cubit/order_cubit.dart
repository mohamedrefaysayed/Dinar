import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/data/models/send_order_model.dart';
import 'package:dinar_store/features/home/data/services/orders_services.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required OrdersServices ordersServices}) : super(OrderInitial()) {
    _ordersServices = ordersServices;
  }

  late OrdersServices _ordersServices;

  static String payment = "الدفع عند الاستلام";

  static DateTime? initialTime;
  static DateTime? pickedTime;
  static LatLng? markerPosition;
  static String currentAddress = "أختر عنوان";
  static Marker? marker;

  static OrdersModel? ordersModel;

  getAllOrders() async {
    ordersModel == null ? emit(OrderLoading()) : null;
    Either<ServerFailure, OrdersModel> result =
        await _ordersServices.getAllOrders(
      token: AppCubit.token!,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          OrderFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (orders) async {
        ordersModel = orders;
        emit(OrderSuccess(ordersModel: orders));
      },
    );
  }

  storeOrder({
    required int status,
    required double discount,
    required double tax,
    required double price,
    required int addressId,
    required String paymentMethod,
  }) async {
    emit(AddToOrdersLoading());

    SendOrderModel sendOrderModel = SendOrderModel();

    List<Map<String, dynamic>> orderDetails = [];
    final now = DateTime.now();

    String date = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime!.hour,
      pickedTime!.minute,
    ).toString();

    for (var cartItem in CartCubit.cartItemsModel!.cart!) {
      orderDetails.add(
        SendOrderDetails(
          productId: int.parse(cartItem.productId!),
          unitId: double.parse(cartItem.unitId!).toInt(),
          qty: double.parse(cartItem.quantity!).toInt(),
          price: double.parse(cartItem.price!).toInt(),
        ).toJson(),
      );
    }
    sendOrderModel = SendOrderModel.fromJson({
      'discount': discount.toInt(),
      'tax': tax.toInt(),
      'address_id': addressId,
      'order_details': orderDetails,
      'payment_method': "الدفع عند الاستلام",
      'location':
          "https://www.google.com/maps?q=${markerPosition!.latitude},${markerPosition!.longitude}",
      'delivery_time': date,
    });

    Either<ServerFailure, void> result = await _ordersServices.storeOrder(
      token: AppCubit.token!,
      status: status,
      discount: discount,
      tax: tax,
      addressId: addressId,
      sendOrderModel: sendOrderModel,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          AddOrderFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (orders) async {
        emit(
          AddOrderSuccess(),
        );
      },
    );
  }

  void addMarker(LatLng position) async {
    markerPosition = position;
    const markerId = MarkerId('marker_id');
    marker = Marker(
      markerId: markerId,
      position: position,
    );
    emit(OrderInitial());

    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      currentAddress = '${place.street}';
      emit(OrderInitial());
    });
  }

  DateTime add24Hours() {
    // TimeOfDay currentTime = TimeOfDay.now();
    // DateTime currentDateTime = DateTime(
    //     DateTime.now().year,
    //     DateTime.now().month,
    //     DateTime.now().day,
    //     currentTime.hour,
    //     currentTime.minute);
    // DateTime newDateTime = currentDateTime.add(const Duration(hours: 24));
    // newDateTime = newDateTime.add(const Duration(minutes: 30));
    // TimeOfDay newTime =
    //     TimeOfDay(hour: newDateTime.hour, minute: newDateTime.minute);
    // return newTime;

    DateTime baseTime = DateTime.now();

    DateTime newDateTime = baseTime.add(const Duration(hours: 24, minutes: 30));
    return newDateTime;
  }

  bool isTimeGreaterBy24Hour(DateTime timeToCompare) {
    // TimeOfDay currentTime = TimeOfDay.now();
    // DateTime currentDateTime = DateTime(
    //     DateTime.now().year,
    //     DateTime.now().month,
    //     DateTime.now().day,
    //     currentTime.hour,
    //     currentTime.minute);
    // DateTime compareDateTime = DateTime(
    //     DateTime.now().year,
    //     DateTime.now().month,
    //     DateTime.now().day,
    //     timeToCompare.hour,
    //     timeToCompare.minute);
    // Duration difference = compareDateTime.difference(currentDateTime);
    // return difference.inHours >= 24;

    DateTime currentTime = DateTime.now();
    Duration difference = timeToCompare.difference(currentTime);
    return difference.inHours >= 24;
  }
}
