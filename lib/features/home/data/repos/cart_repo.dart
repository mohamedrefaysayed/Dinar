import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/cart_items_model.dart';

abstract class CartRepo {
  Future<Either<ServerFailure, CartItemsModel>> getAllItems({
    required String token,
  });

  Future<Either<ServerFailure, void>> storeItem({
    required bool isRetail,
    required String token,
    required int productId,
    required int quantity,
    required int unitId,
    required double price,
    required String isRequired,
  });

  Future<Either<ServerFailure, void>> deleteItem({
    required String token,
    required int itemId,
  });

  Future<Either<ServerFailure, void>> updateItem({
    required String token,
    required int productId,
    required int quantity,
    required int unitId,
    required double price,
    required String isRequired,
    required int itemId,
  });
}
