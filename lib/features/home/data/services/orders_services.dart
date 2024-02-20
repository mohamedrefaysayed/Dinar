import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/features/home/data/models/cart_items_model.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/data/models/send_order_model.dart';
import 'package:dinar_store/features/home/data/repos/orders_repo.dart';
import 'package:dio/dio.dart';

class OrdersServices implements OrdersRepo {
  OrdersServices({
    required DioHelper dioHelper,
  }) {
    _dioHelper = dioHelper;
  }

  late DioHelper _dioHelper;

  String? fcmToken;

  @override
  Future<Either<ServerFailure, OrdersModel>> getAllOrders(
      {required String token}) async {
    OrdersModel ordersModel = OrdersModel();
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'orders',
      );
      ordersModel = OrdersModel.fromJson(data);
      return right(ordersModel);
    } on DioException catch (error) {
      return left(
        ServerFailure.fromDioException(dioException: error),
      );
    } catch (error) {
      return left(
        ServerFailure(errMessage: error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerFailure, void>> storeOrder({
    required String token,
    required int status,
    required double discount,
    required double tax,
    required int addressId,
    required SendOrderModel sendOrderModel,
  }) async {
    try {
      await _dioHelper.postRequest(
        token: token,
        endPoint: 'orders',
        body: sendOrderModel.toJson(),
      );
      return right(null);
    } on DioException catch (error) {
      return left(
        ServerFailure.fromDioException(dioException: error),
      );
    } catch (error) {
      return left(
        ServerFailure(errMessage: error.toString()),
      );
    }
  }

  @override
  Future<Either<ServerFailure, CartItemsModel>> deleteOrder({
    required String token,
    required int itemId,
  }) async {
    CartItemsModel cartItemsModel;
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
        token: token,
        endPoint: 'orders/$itemId',
        body: {
          '_method': "delete",
          'id': itemId,
        },
      );
      cartItemsModel = CartItemsModel.fromJson(data);
      return right(cartItemsModel);
    } on DioException catch (error) {
      return left(
        ServerFailure.fromDioException(dioException: error),
      );
    } catch (error) {
      return left(
        ServerFailure(errMessage: error.toString()),
      );
    }
  }
}
