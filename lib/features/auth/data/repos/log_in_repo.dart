import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LogInRepo {
  Future<Either<ServerFailure, dynamic>> register({
    required String countryCode,
    required String phoneNumber,
  });

  Future<Either<ServerFailure, dynamic>> sendVCode({
    required String code,
  });

  Future<Either<ServerFailure, Store>> storeData({
    required String ownerName,
    required String storeName,
    required String district,
    required String address,
    required String phone,
    required LatLng position,
    required String token,
  });
  Future<Either<ServerFailure, void>> deleteAccount();

  ///use flutter secure storage to store the token
  Future<void> storeTokenInSecureStorage({
    required String token,
  });
}
