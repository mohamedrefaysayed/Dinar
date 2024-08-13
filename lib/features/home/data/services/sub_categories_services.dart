import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/data/repos/sub_categories_repo.dart';
import 'package:dio/dio.dart';

class SubCategoriesServices implements SubCategoriesRepo {
  SubCategoriesServices({
    required DioHelper dioHelper,
  }) {
    _dioHelper = dioHelper;
  }

  late DioHelper _dioHelper;

  @override
  Future<Either<ServerFailure, List<SubCategories>>> getAllSubCategories({
    required String token,
    required int catId,
  }) async {
    List<SubCategories> subCategories = [];
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'categories/show_by_parent/$catId',
      );
      await data['categories'].forEach((v) {
        subCategories.add(SubCategories.fromJson(v));
      });
      return right(subCategories);
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
  Future<Either<ServerFailure, SubCategoryProductsModel>>
      getSubCategoryWithProduct({
    required String token,
    required int catId,
  }) async {
    SubCategoryProductsModel subCategoryProductsModel;
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'products/show_by_category/$catId',
      );
      subCategoryProductsModel = SubCategoryProductsModel.fromJson(data);
      return right(subCategoryProductsModel);
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
  Future<Either<ServerFailure, List<Products>>> getComapnyWithProduct({
    required String token,
    required int companyId,
  }) async {
    List<Products> products = [];
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'products/show_by_company/$companyId',
      );
      await data['products'].forEach((v) {
        products.add(Products.fromJson(v));
      });
      return right(products);
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
  Future<Either<ServerFailure, Products>> getProduct({
    required String token,
    required int productId,
  }) async {
    try {
      Map<String, dynamic> data = await _dioHelper.getRequest(
        token: token,
        endPoint: 'products/$productId',
      );
      return right(Products.fromJson(data['products']));
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
