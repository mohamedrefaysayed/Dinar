import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/app_cache/cahch_helper.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/core/helpers/push_token.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/core/utils/genrall.dart';
import 'package:dinar_store/core/utils/json_parse.dart';
import 'package:dinar_store/features/auth/data/repos/log_in_repo.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:latlong2/latlong.dart';
import 'dart:developer';

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
      ///the fcm registration token on both platforms, see [PushToken].
      ///this never throws and gives up quickly, so a device without push
      ///still signs in
      fcmToken = await PushToken.get();

      Map<String, dynamic> data = await _dioHelper.postRequest(
        body: {
          ///the api documents this as 'fcm_token'; 'fcm' is kept so the
          ///field keeps working if the backend still reads the old key
          'fcm_token': fcmToken,
          'fcm': fcmToken,
          'token_device': Platform.isIOS ? 'flutter-ios' : 'flutter-android',
          'verification_code': code,
        },
        endPoint: 'verify',
      );
      ///the api returns role as the string "0", not a number
      role = asInt(data['user']?['role']);
      CahchHelper.saveData(key: 'role', value: role);
      log(data.toString());
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
  Future<Either<ServerFailure, Store>> storeData({
    String? ownerName,
    String? storeName,
    String? district,
    String? address,
    String? phone,
    LatLng? position,
    required String token,
    bool? isUpdate = false,
    int? storeId,
  }) async {
    Store store = Store();
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
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
        endPoint: isUpdate ? 'store/$storeId' : 'store',
      );
      store = Store.fromJson(data);
      return right(isUpdate ? store : Store());
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
  Future<Either<ServerFailure, Store>> updateProfile({
    required String token,
    String? ownerName,
    String? storeName,
    String? district,
    String? address,
    String? storePhone,
    required double lat,
    required double lng,
  }) async {
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
        token: token,
        endPoint: 'update-profile',
        body: {
          ///the store owner name doubles as the account name, matching the
          ///backend's documented update-profile payload
          if (ownerName != null) 'name': ownerName,
          if (ownerName != null) 'owner_name': ownerName,
          if (storeName != null) 'store_name': storeName,
          if (district != null) 'district': district,
          if (address != null) 'address': address,

          ///the store number must be sent as 'store_phone'. sending it as
          ///'phone' changes the user's login number instead of the store's
          if (storePhone != null) 'store_phone': storePhone,
          'lat': lat,
          'lng': lng,
        },
      );

      ///the backend rotates the auth token on this call. keeping the old one
      ///makes every later request 401, which signed the user out the moment
      ///they edited their data. persist the new token before anything else runs
      final String? newToken = asStringOrNull(data['token']);
      if (newToken != null && newToken.isNotEmpty) {
        await storeTokenInSecureStorage(token: newToken);
      }

      ///the response carries the updated user with the store nested inside it
      final ProfileModel profileModel = ProfileModel.fromJson(data);
      Store? store;
      if (profileModel.user != null && profileModel.user!.isNotEmpty) {
        store = profileModel.user!.first.store;
      }
      return right(store ?? Store());
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
