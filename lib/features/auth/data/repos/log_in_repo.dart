import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:latlong2/latlong.dart';

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
  ///edit the store/profile via /update-profile. the backend rotates the auth
  ///token on this call and returns the new one, so it must be persisted or
  ///every later request 401s and the user is signed out right after saving
  Future<Either<ServerFailure, Store>> updateProfile({
    required String token,
    String? ownerName,
    String? storeName,
    String? district,
    String? address,
    String? storePhone,
    required double lat,
    required double lng,
  });

  Future<Either<ServerFailure, void>> deleteAccount();

  ///use flutter secure storage to store the token
  Future<void> storeTokenInSecureStorage({
    required String token,
  });
}
