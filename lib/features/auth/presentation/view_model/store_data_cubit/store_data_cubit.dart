import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/auth/data/services/log_in_services.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
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
      isUpdate: false,
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

    final Store store = profileModel.user!.first.store!;

    Either<ServerFailure, Store> result = await _logInServices.updateProfile(
      token: AppCubit.token!,
      ownerName:
          nameController.text.isNotEmpty ? nameController.text : store.ownerName,
      storeName: marketNameController.text.isNotEmpty
          ? marketNameController.text
          : store.storeName,
      district:
          govController.text.isNotEmpty ? govController.text : store.district,
      address: addressController.text.isNotEmpty
          ? addressController.text
          : store.address,
      storePhone: marketPhoneController.text.isNotEmpty
          ? marketPhoneController.text
          : store.phone,
      lat: store.lat!,
      lng: store.lng!,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          UpdateDataFailure(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (store) async {
        ProfileCubit.profileModel!.user!.first.store = store;

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

    final Store store = profileModel.user!.first.store!;

    Either<ServerFailure, Store> result = await _logInServices.updateProfile(
      token: AppCubit.token!,
      ownerName: store.ownerName,
      storeName: store.storeName,
      district: store.district,
      address: store.address,
      storePhone: store.phone,
      lat: position.latitude,
      lng: position.longitude,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          UpdateLocationFailure(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (store) async {
        ProfileCubit.profileModel!.user!.first.store = store;

        emit(UpdateLocationSuccess());
        LocationCubit.currentPosition == null;
      },
    );
  }
}
