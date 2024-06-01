// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/data/services/sub_categories_services.dart';
import 'package:flutter/material.dart';

part 'sub_category_product_state.dart';

class SubCategoryProductCubit extends Cubit<SubCategoryProductState> {
  SubCategoryProductCubit(
      {required SubCategoriesServices subCategoriesServices})
      : super(SubCategoryProductInitial()) {
    _subCategoriesServices = subCategoriesServices;
  }

  late SubCategoriesServices _subCategoriesServices;

  static SubCategoryProductsModel subCategoryProductsModel =
      SubCategoryProductsModel(products: []);
  static SubCategoryProductsModel subCategoryProductsModelSearch =
      SubCategoryProductsModel(products: []);
  static TextEditingController subCategoriesController =
      TextEditingController();

  getSubCategoryWithProduct({required int catId}) async {
    emit(SubCategoryProductLoading());
    Either<ServerFailure, SubCategoryProductsModel> result =
        await _subCategoriesServices.getSubCategoryWithProduct(
            token: AppCubit.token!, catId: catId);

    result.fold(
      //error
      (serverFailure) {
        emit(
          SubCategoryProductFaliuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (subCategoryProducts) async {
        subCategoryProductsModel = subCategoryProducts;
        emit(SubCategoryProductSuccess(
            subCategoryProductsModel: subCategoryProducts));
      },
    );
  }

  getCompanyWithProduct({required int companyId}) async {
    emit(SubCategoryProductLoading());
    Either<ServerFailure, List<Products>> result = await _subCategoriesServices
        .getComapnyWithProduct(token: AppCubit.token!, companyId: companyId);

    result.fold(
      //error
      (serverFailure) {
        emit(
          SubCategoryProductFaliuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (products) async {
        emit(SubCategoryProductSuccess(
            subCategoryProductsModel:
                SubCategoryProductsModel(products: products)));
      },
    );
  }

  searchInProducts() {
    subCategoryProductsModelSearch = SubCategoryProductsModel(products: []);
    for (var element in subCategoryProductsModel.products!) {
      if (element.productName!
          .toLowerCase()
          .contains(subCategoriesController.text.toLowerCase())) {
        subCategoryProductsModelSearch.products!.add(element);
      }
      emit(SubCategoryProductSuccess(
          subCategoryProductsModel: subCategoryProductsModel));
    }
  }
}
