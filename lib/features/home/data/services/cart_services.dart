import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/features/home/data/models/cart_items_model.dart';
import 'package:dinar_store/features/home/data/repos/cart_repo.dart';
import 'package:dio/dio.dart';

class CartServices implements CartRepo {
  CartServices({
    required DioHelper dioHelper,
  }) {
    _dioHelper = dioHelper;
  }

  late DioHelper _dioHelper;

  String? fcmToken;

  @override
  Future<Either<ServerFailure, CartItemsModel>> getAllItems(
      {required String token}) async {
    CartItemsModel cartItemsModel = CartItemsModel();
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'cart',
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

  @override
  Future<Either<ServerFailure, int>> storeItem({
    required bool isRetail,
    required String token,
    required int productId,
    required int quantity,
    required int unitId,
    required double price,
    required String isRequired,
    int? refrenceId,
  }) async {
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
        token: token,
        endPoint: 'cart',
        body: {
          'unit_type' : isRetail ? 'retail' : 'whole',
          'product_id': productId,
          'quantity': quantity,
          'unit_id': unitId,
          'price': price,
          'is_required': isRequired,
          if (refrenceId != null) "ref_cart_id": refrenceId,
        },
      );
      return right(data['inserted_item'] ?? 0);
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
  Future<Either<ServerFailure, CartItemsModel>> deleteItem({
    required String token,
    required int itemId,
  }) async {
    CartItemsModel cartItemsModel;
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
        token: token,
        endPoint: 'cart/$itemId',
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

  @override
  Future<Either<ServerFailure, CartItemsModel>> updateItem({
    required String token,
    required int productId,
    required int quantity,
    required int unitId,
    required double price,
    required String isRequired,
    required int itemId,
  }) async {
    CartItemsModel cartItemsModel;
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
        token: token,
        endPoint: 'cart/$itemId',
        body: {
          '_method': "put",
          'product_id': productId,
          'quantity': quantity,
          'unit_id': unitId,
          'price': price,
          'is_required': isRequired,
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
