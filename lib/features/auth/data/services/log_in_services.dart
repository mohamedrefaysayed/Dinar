import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/features/auth/data/repos/log_in_repo.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LogInServices implements LogInRepo {
  LogInServices({
    required DioHelper dioHelper,
    required FlutterSecureStorage secureStorage,
  }) {
    _dioHelper = dioHelper;
    _secureStorage = secureStorage;
  }

  late DioHelper _dioHelper;
  late FlutterSecureStorage _secureStorage;
  String? fcmToken;

  @override
  Future<Either<ServerFailure, Map<String, dynamic>>> register({
    required String countryCode,
    required String phoneNumber,
  }) async {
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
        body: {
          'country_code': countryCode,
          'phone': phoneNumber,
        },
        endPoint: 'register',
      );

      return right(data);
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
  Future<Either<ServerFailure, Map<String, dynamic>>> sendVCode({
    required String code,
  }) async {
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      Map<String, dynamic> data = await _dioHelper.postRequest(
        body: {
          'fcm': fcmToken,
          'verification_code': code,
        },
        endPoint: 'verify',
      );
      return right(data);
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
  Future<Either<ServerFailure, void>> storeData({
    String? ownerName,
    String? storeName,
    String? district,
    String? address,
    String? phone,
    LatLng? position,
    required String token,
    bool? isUpdate = false,
  }) async {
    try {
      await _dioHelper.postRequest(
        token: token,
        body: {
          if (isUpdate!) '_method': "put",
          if (ownerName != null) 'owner_name': ownerName,
          if (storeName != null) 'store_name': storeName,
          if (district != null) 'district': district,
          if (address != null) 'address': address,
          if (phone != null) 'phone': phone,
          if (position != null) 'lng': position.longitude,
          if (position != null) 'lat': position.latitude,
        },
        endPoint: isUpdate ? 'store/1' : 'store',
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
  Future<Either<ServerFailure, void>> deleteAccount() async {
    try {
      await _dioHelper.postRequest(
        endPoint: 'delete_account',
        token: AppCubit.token,
        body: {},
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
  Future<void> storeTokenInSecureStorage({required String token}) async {
    AppCubit.token = token;
    await _secureStorage.write(key: kSecureStorageKey, value: token);
  }
}
