import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/auth/data/services/log_in_services.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'store_data_state.dart';

class StoreDataCubit extends Cubit<StoreDataState> {
  StoreDataCubit({
    required LogInServices logInServices,
  }) : super(StoreDataInitial()) {
    _logInServices = logInServices;
  }

  late LogInServices _logInServices;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static TextEditingController nameController = TextEditingController();
  static TextEditingController marketNameController = TextEditingController();
  static TextEditingController govController = TextEditingController();
  static TextEditingController addressController = TextEditingController();
  static TextEditingController marketPhoneController = TextEditingController();

  Future<void> storeData() async {
    emit(StoreDataLoading());

    Either<ServerFailure, void> result = await _logInServices.storeData(
      ownerName: nameController.text,
      storeName: marketNameController.text,
      district: govController.text,
      address: addressController.text,
      phone: marketPhoneController.text,
      position: LatLng(
        LocationCubit.currentPosition!.latitude,
        LocationCubit.currentPosition!.longitude,
      ),
      token: AppCubit.token!,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          StoreDataFailure(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (data) async {
        emit(StoreDataSuccess());
        nameController.clear();
        marketNameController.clear();
        govController.clear();
        addressController.clear();
        marketPhoneController.clear();
        LocationCubit.currentPosition == null;
      },
    );
  }

  Future<void> updateData({required ProfileModel profileModel}) async {
    emit(UpdateDataLoading());

    Either<ServerFailure, void> result = await _logInServices.storeData(
      isUpdate: true,
      ownerName: nameController.text.isNotEmpty
          ? nameController.text
          : profileModel.user!.first.store!.ownerName,
      storeName: marketNameController.text.isNotEmpty
          ? marketNameController.text
          : profileModel.user!.first.store!.storeName,
      district: govController.text.isNotEmpty
          ? govController.text
          : profileModel.user!.first.store!.district,
      address: addressController.text.isNotEmpty
          ? addressController.text
          : profileModel.user!.first.store!.address,
      phone: marketPhoneController.text.isNotEmpty
          ? marketPhoneController.text
          : profileModel.user!.first.store!.phone,
      token: AppCubit.token!,
      position: LatLng(
        double.parse(profileModel.user!.first.store!.lat!),
        double.parse(profileModel.user!.first.store!.lng!),
      ),
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          UpdateDataFailure(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (data) async {
        emit(UpdateDataSuccess());
        nameController.clear();
        marketNameController.clear();
        govController.clear();
        addressController.clear();
        marketPhoneController.clear();
        LocationCubit.currentPosition == null;
      },
    );
  }

  Future<void> updateLocation(
      {required LatLng position, required ProfileModel profileModel}) async {
    emit(UpdateLocationLoading());

    Either<ServerFailure, void> result = await _logInServices.storeData(
      isUpdate: true,
      position: position,
      token: AppCubit.token!,
      ownerName: profileModel.user!.first.store!.ownerName,
      storeName: profileModel.user!.first.store!.storeName,
      district: profileModel.user!.first.store!.district,
      address: profileModel.user!.first.store!.address,
      phone: profileModel.user!.first.store!.phone,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          UpdateLocationFailure(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (data) async {
        emit(UpdateLocationSuccess());
        LocationCubit.currentPosition == null;
      },
    );
  }
}
