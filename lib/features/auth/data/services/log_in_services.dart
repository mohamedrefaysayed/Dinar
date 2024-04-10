import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/features/auth/data/repos/log_in_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

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

      Map<String, dynamic> data = await _dioHelper.postRequest(
        body: {
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
    required String ownerName,
    required String storeName,
    required String district,
    required String address,
    required String phone,
    required Position position,
    required String token,
  }) async {
    try {
      await _dioHelper.postRequest(
        token: token,
        body: {
          'owner_name': ownerName,
          'store_name': storeName,
          'district': district,
          'address': address,
          'phone': phone,
          'lng': position.longitude,
          'lat': position.latitude,
        },
        endPoint: 'store',
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
