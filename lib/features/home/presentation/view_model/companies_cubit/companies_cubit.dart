// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/companies_model.dart';
import 'package:dinar_store/features/home/data/services/companies_services.dart';
import 'package:flutter/material.dart';

part 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  CompaniesCubit({required CompaniesServices companiesServices})
      : super(CompaniesInitial()) {
    _companiesServices = companiesServices;
  }

  late CompaniesServices _companiesServices;
  static CompaniesModel companiesModel = CompaniesModel();
  static CompaniesModel companiesSearchModel = CompaniesModel(companies: []);
  static TextEditingController companySearchController =
      TextEditingController();

  getAllCompanies() async {
    emit(CompaniesLoading());
    Either<ServerFailure, CompaniesModel> result =
        await _companiesServices.getAllCompanies(token: AppCubit.token ?? '');

    result.fold(
      //error
      (serverFailure) {
        emit(
          CompaniesFaliuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (companiesModel) async {
        emit(CompaniesSuccess(companiesModel: companiesModel));
      },
    );
  }

  searchInSubCompanies() {
    companiesSearchModel.companies = [];
    for (var element in companiesModel.companies!) {
      if (element.companyName!
          .toLowerCase()
          .contains(companySearchController.text.toLowerCase())) {
        companiesSearchModel.companies!.add(element);
      }
      emit(CompaniesSuccess(companiesModel: companiesModel));
    }
  }
}
