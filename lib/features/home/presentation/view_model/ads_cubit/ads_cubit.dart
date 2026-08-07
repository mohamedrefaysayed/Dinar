// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/home/data/models/ads_model.dart';
import 'package:dinar_store/features/home/data/services/ads_services.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  AdsCubit({required AdsServices adsServices}) : super(AdsInitial()) {
    _adsServices = adsServices;
  }

  late AdsServices _adsServices;

  getAllAds() async {
    emit(AdsLoading());
    Either<ServerFailure, AdsModel> result =
        await _adsServices.getAllAds(token: AppCubit.token ?? '');

    result.fold(
      //error
      (serverFailure) {
        emit(
          AdsFaliuer(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (adsModel) async {
        emit(AdsSuccess(adsModel: adsModel));
      },
    );
  }
}
