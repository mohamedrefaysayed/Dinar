import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';

abstract class SubCategoriesRepo {
  Future<Either<ServerFailure, List<SubCategories>>> getAllSubCategories({
    required String token,
    required int catId,
  });
  Future<Either<ServerFailure, SubCategoryProductsModel>>
      getSubCategoryWithProduct({
    required String token,
    required int catId,
  });
  Future<Either<ServerFailure, List<Products>>> getComapnyWithProduct({
    required String token,
    required int companyId,
  });

  Future<Either<ServerFailure, Products>> getProduct({
    required String token,
    required int productId,
  });
}
