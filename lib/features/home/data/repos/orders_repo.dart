import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/data/models/send_order_model.dart';

abstract class OrdersRepo {
  Future<Either<ServerFailure, OrdersModel>> getAllOrders({
    required String token,
  });

  Future<Either<ServerFailure, DinarOrder>> getOrder({
    required String token,
    required int orderId,
  });

  Future<Either<ServerFailure, void>> storeOrder({
    required String token,
    required SendOrderModel sendOrderModel,
  });

  Future<Either<ServerFailure, void>> deleteOrder({
    required String token,
    required int itemId,
  });
}
