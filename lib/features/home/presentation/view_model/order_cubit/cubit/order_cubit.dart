import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/data/models/send_order_model.dart';
import 'package:dinar_store/features/home/data/services/orders_services.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

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

  ///where the user has actually tapped on the delivery map. Distinct from
  ///[markerPosition], which the order-confirm screen pre-seeds with the
  ///device's own location — until this is set, no pin is drawn and the map
  ///still prompts "أختر موقع التوصيل"
  static LatLng? pickedPosition;

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
          currentOrders: orders.currentOrders,
          oldOrders: orders.oldOrders,
        );
        emit(OrderSuccess(ordersModel: orders));
      },
    );
  }

  getAllOrdersForDelevry() async {
    ordersModel == null ? emit(OrderLoading()) : null;
    Either<ServerFailure, OrdersModel> result =
        await _ordersServices.getAllOrdersForDelevry(
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
          currentOrders: orders.currentOrders,
          oldOrders: orders.oldOrders,
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
    required String deliveryFees,
    required String notes,
  }) async {
    emit(AddToOrdersLoading());

    SendOrderModel sendOrderModel = SendOrderModel();

    List<Map<String, dynamic>> orderDetails = [];

    ///DateTime.toString() is 'yyyy-MM-dd HH:mm:ss.mmmmmm', and taking 18
    ///characters cut the seconds in half ('2026-08-10 23:00:0'), which the
    ///backend stored verbatim and DateTime.parse then rejected with
    ///"Invalid date format" on every order row
    final String date = _formatDeliveryTime(pickedTime);

    for (var cartItem in CartCubit.cartItemsModel!.cart!) {
      orderDetails.add(
        SendOrderDetails(
          productId: cartItem.productId!,
          unitId: cartItem.unitId!,
          qty: cartItem.quantity!,
          price: cartItem.price!,
          unitType: cartItem.unitType!,
        ).toJson(),
      );
    }

    sendOrderModel = SendOrderModel.fromJson(
      {
        'status': status,
        'discount': discount.toInt(),
        'tax': tax.toInt(),
        'order_details': orderDetails,
        'payment_method': "عند الاستلام",
        'location':
            "https://www.google.com/maps?q=${markerPosition!.latitude},${markerPosition!.longitude}",
        'delivery_time': date,
        'address': currentAddress,
        'delivery_fees': deliveryFees,
        'notes': notes,
      },
    );

    Either<ServerFailure, DinarOrder> result = await _ordersServices.storeOrder(
      token: AppCubit.token!,
      sendOrderModel: sendOrderModel,
    );

    result.fold(
      //error
      (serverFailure) {
        if (kDebugMode) {
          print(serverFailure.errMessage);
        }
        emit(
          AddOrderFailuer(errMessage: serverFailure.errMessage),
        );
      },

      //success
      (order) async {
        emit(
          AddOrderSuccess(
            dinarOrder: order,
          ),
        );
      },
    );
  }

  changeOrderStatus({
    required DinarOrder order,
  }) async {
    emit(UpdateOrderLoading());
    Either<ServerFailure, void> result =
        await _ordersServices.changeOrderStatus(
      token: AppCubit.token!,
      orderId: order.id!,
      status: "4",
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          UpdateOrderFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (_) {
        emit(
          ChangeStatusSuccess(),
        );
      },
    );
  }

  void addMarker(LatLng position) async {
    markerPosition = position;
    pickedPosition = position;
    emit(OrderInitial());

    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      currentAddress = '${place.street}';
      emit(OrderInitial());
    });
  }

  ///'yyyy-MM-dd HH:mm:ss', the format the api stores and DateTime.parse reads
  static String _formatDeliveryTime(DateTime? time) {
    final DateTime value = time ?? DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${value.year}-${two(value.month)}-${two(value.day)} '
        '${two(value.hour)}:${two(value.minute)}:${two(value.second)}';
  }

  DateTime add24Hours() {
    DateTime baseTime = DateTime.now();

    DateTime newDateTime = baseTime.add(const Duration(hours: 24, minutes: 10));
    return newDateTime;
  }

  DateTime minimumDeliveryTime() {
    return DateTime.now().add(const Duration(hours: 24));
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
    return difference >= const Duration(hours: 24);
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
        return "تم الإراجاع";
    }
  }

  ///reads the coordinates back out of the 'maps?q=lat,lng' link the api stores
  ///against an order.
  ///
  ///every failure falls back rather than throwing: google's LatLng used to
  ///clamp whatever it was handed, but latlong2 takes any double as-is and the
  ///map layer throws on a non-finite point — so a malformed location string
  ///would take down the whole order-details screen instead of showing the
  ///fallback pin
  List<double> extractLatLng(String url) {
    const List<double> fallback = [28.8993468, 76.6250249];
    try {
      final List<String> latLng =
          Uri.parse(url).queryParameters['q']?.split(',') ?? const [];
      if (latLng.length != 2) return fallback;

      final double lat = double.parse(latLng[0]);
      final double lng = double.parse(latLng[1]);

      ///every comparison against NaN is false, so it has to be excluded by
      ///itself before the range check can mean anything
      if (!lat.isFinite || !lng.isFinite) return fallback;
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return fallback;

      return [lat, lng];
    } catch (_) {
      return fallback;
    }
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
