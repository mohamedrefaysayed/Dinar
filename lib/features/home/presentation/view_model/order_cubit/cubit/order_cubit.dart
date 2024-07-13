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
  static String currentAddress = "لا يوجد عنوان";
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
      (orders) {
        ordersModel = OrdersModel(
          currentOrders: orders.currentOrders!.reversed.toList(),
          oldOrders: orders.oldOrders!,
        );
        emit(OrderSuccess(ordersModel: orders));
      },
    );
  }

   getOrder({required int orderId}) async {
    emit(UpdateOrderLoading());
    Either<ServerFailure, DinarOrder> result = await _ordersServices.getOrder(
      token: AppCubit.token!,
      orderId: orderId,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          UpdateOrderFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (order) {
        emit(UpdateOrderSuccess(order: order));
      },
    );
  }

  storeOrder({
    required int status,
    required double discount,
    required double tax,
    required double price,
    required String paymentMethod,
  }) async {
    emit(AddToOrdersLoading());

    SendOrderModel sendOrderModel = SendOrderModel();

    List<Map<String, dynamic>> orderDetails = [];

    String date = pickedTime.toString().substring(0, 18);

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

    sendOrderModel = SendOrderModel.fromJson(
      {
        'discount': discount.toInt(),
        'tax': tax.toInt(),
        'order_details': orderDetails,
        'payment_method': "عند الاستلام",
        'location':
            "https://www.google.com/maps?q=${markerPosition!.latitude},${markerPosition!.longitude}",
        'delivery_time': date,
        'address': currentAddress,
      },
    );

    Either<ServerFailure, void> result = await _ordersServices.storeOrder(
      token: AppCubit.token!,
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

// Function to get status message
  String getStatusMessage(String statusNumber) {
    OrderStatus status;
    switch (statusNumber) {
      case "0":
        status = OrderStatus.orderd;
        break;
      case "1":
        status = OrderStatus.underReview;
        break;
      case "2":
        status = OrderStatus.preparing;
        break;
      case "3":
        status = OrderStatus.delivering;
        break;
      case "4":
        status = OrderStatus.delivered;
        break;
      case "5":
        status = OrderStatus.cancelled;
        break;
      default:
        status = OrderStatus.returned;
    }

    switch (status) {
      case OrderStatus.orderd:
        return "تم الطلب";
      case OrderStatus.underReview:
        return "قيد المراجعة";
      case OrderStatus.preparing:
        return "قيد التحضير";
      case OrderStatus.delivering:
        return "قيد التوصيل";
      case OrderStatus.delivered:
        return "تم التوصيل";
      case OrderStatus.cancelled:
        return "تم الغاء الطلب";
      case OrderStatus.returned:
      default:
        return "تم الإراجاع";
    }
  }

  List<double> extractLatLng(String url) {
    Uri uri = Uri.parse(url);
    List<String> latLng = uri.queryParameters['q']?.split(',') ?? [];
    if (latLng.length == 2) {
      double lat = double.parse(latLng[0]);
      double lng = double.parse(latLng[1]);
      return [lat, lng];
    }
    return [28.8993468, 76.6250249];
  }

// Usage
}

enum OrderStatus {
  orderd, // corresponds to "0"
  underReview, // corresponds to "1"
  preparing, // corresponds to "2"
  delivering, // corresponds to "3"
  delivered, // corresponds to "4"
  cancelled, // corresponds to "5"
  returned, // corresponds to any other value
}
