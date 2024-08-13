part of 'sub_category_product_cubit.dart';

sealed class SubCategoryProductState {}

final class SubCategoryProductInitial extends SubCategoryProductState {}

final class SubCategoryProductLoading extends SubCategoryProductState {}

final class SubCategoryProductSuccess extends SubCategoryProductState {
  final SubCategoryProductsModel subCategoryProductsModel;
  SubCategoryProductSuccess({required this.subCategoryProductsModel});
}

final class SubCategoryProductFaliuer extends SubCategoryProductState {
  final String errMessage;
  SubCategoryProductFaliuer({required this.errMessage});
}

final class ProductLoading extends SubCategoryProductState {}

final class ProductSuccess extends SubCategoryProductState {
  final Products products;
  ProductSuccess({required this.products});
}

final class ProductFaliuer extends SubCategoryProductState {
  final String errMessage;
  ProductFaliuer({required this.errMessage});
}
