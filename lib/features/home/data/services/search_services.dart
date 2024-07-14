import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/features/home/data/models/search_model.dart';
import 'package:dinar_store/features/home/data/repos/search_repo.dart';
import 'package:dio/dio.dart';

class SearchServices implements SearchRepo {
  SearchServices({
    required DioHelper dioHelper,
  }) {
    _dioHelper = dioHelper;
  }

  late DioHelper _dioHelper;

  @override
  Future<Either<ServerFailure, SearchModel>> search({
    required String token,
    required String keyWord,
  }) async {
    SearchModel searchModel = SearchModel();
    try {
      Map<String, dynamic> data = await _dioHelper.postRequest(
        token: token,
        endPoint: 'search',
        body: {
          'keyword': keyWord,
        },
      );
      searchModel = SearchModel.fromJson(data);
      return right(searchModel);
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
