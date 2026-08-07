// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/data/services/categories_services.dart';
import 'package:flutter/material.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({required CategoriesServices categoriesServices})
      : super(CategoriesInitial()) {
    _categoriesServices = categoriesServices;
  }

  late CategoriesServices _categoriesServices;

  static int selectedIndex = 0;

  static PageController pageController = PageController();

  getAllCategories() async {
    emit(CategoriesLoading());
    Either<ServerFailure, CategoriesModel> result =
        await _categoriesServices.getAllCategories(token: AppCubit.token ?? '');

    result.fold(
      //error
      (serverFailure) {
        emit(
          CategoriesFaliuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (categoriesModel) async {
        emit(CategoriesSuccess(categoriesModel: categoriesModel));
      },
    );
  }

  changeCategory(
      {required index, required CategoriesModel categoriesModel}) async {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    emit(CategoriesSuccess(categoriesModel: categoriesModel));
  }
}
