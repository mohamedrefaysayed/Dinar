import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:dinar_store/features/home/data/repos/Profile_repo.dart';
import 'package:dio/dio.dart';

class ProfileServices implements ProfileRepo {
  ProfileServices({
    required DioHelper dioHelper,
  }) {
    _dioHelper = dioHelper;
  }

  late DioHelper _dioHelper;

  @override
  Future<Either<ServerFailure, ProfileModel>> getProfile(
      {required String token}) async {
    ProfileModel profileModel;
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'get-user',
      );
      profileModel = ProfileModel.fromJson(data);
      return right(profileModel);
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
