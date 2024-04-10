import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/features/home/data/models/ads_model.dart';
import 'package:dinar_store/features/home/data/repos/ads_repo.dart';
import 'package:dio/dio.dart';

class AdsServices implements AdsRepo {
  AdsServices({
    required DioHelper dioHelper,
  }) {
    _dioHelper = dioHelper;
  }

  late DioHelper _dioHelper;

  String? fcmToken;

  @override
  Future<Either<ServerFailure, AdsModel>> getAllAds(
      {required String token}) async {
    AdsModel adsModel;
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'ads',
      );
      adsModel = AdsModel.fromJson(data);
      if (adsModel.ads == null) {
        return right(AdsModel(ads: []));
      }
      return right(adsModel);
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
