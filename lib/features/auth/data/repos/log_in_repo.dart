import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:geolocator/geolocator.dart';

abstract class LogInRepo {
  Future<Either<ServerFailure, dynamic>> register({
    required String countryCode,
    required String phoneNumber,
  });

  Future<Either<ServerFailure, dynamic>> sendVCode({
    required String code,
  });

  Future<Either<ServerFailure, dynamic>> storeData({
    required String ownerName,
    required String storeName,
    required String district,
    required String address,
    required String phone,
    required Position position,
    required String token,
  });

  ///use flutter secure storage to store the token
  Future<void> storeTokenInSecureStorage({
    required String token,
  });
}
