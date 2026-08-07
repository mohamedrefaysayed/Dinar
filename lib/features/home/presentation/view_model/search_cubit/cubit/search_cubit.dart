import 'package:bloc/bloc.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/search_model.dart';
import 'package:dinar_store/features/home/data/services/search_services.dart';
import 'package:flutter/material.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchServices searchServices})
      : super(SearchInitial()) {
    _searchServices = searchServices;
  }

  late SearchServices _searchServices;

  static SearchModel? searchModel;

  static TextEditingController searchController = TextEditingController();

  static ValueNotifier<Map<String, bool>> filter =
      ValueNotifier<Map<String, bool>>(
          {'companies': true, 'categories': true, 'products': true});

  search({required String keyWord}) async {
    searchModel == null ? emit(SearchLoading()) : null;
    Either<ServerFailure, SearchModel> result = await _searchServices.search(
      token: AppCubit.token ?? '',
      keyWord: keyWord,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          SearchFailuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (searchResult) async {
        searchModel = searchResult;
        emit(SearchSuccess(searchModel: searchResult));
      },
    );
  }
}
