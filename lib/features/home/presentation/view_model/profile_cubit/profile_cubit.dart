// ignore_for_file: depend_on_referenced_packages

import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/functions/profile_validator.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:dinar_store/features/home/data/services/profile_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileServices profileServices,
  }) : super(ProfileInitial()) {
    _profileServices = profileServices;
  }

  late ProfileServices _profileServices;

  ///where the pin currently sits on the edit-location map — seeded with the
  ///store's saved coordinates when the screen opens, then moved by every tap
  static LatLng? pickedPosition;

  static String currentAddress = "";

  static ProfileModel? profileModel;

  getProfile({required BuildContext context}) async {
    emit(ProfileLoading());
    Either<ServerFailure, ProfileModel> result =
        await _profileServices.getProfile(
      token: AppCubit.token!,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          ProfileFaliuer(
            errMessage: serverFailure.errMessage,
            statusCode: serverFailure.statusCode,
          ),
        );
      },
      //success
      (newProfileModel) async {
        profileModel = newProfileModel;

        ///a user who has not created a store yet has no coordinates to
        ///reverse geocode, so resolving the address is best effort
        final Store? store = newProfileModel.user?.firstOrNull?.store;
        final double? lat = store?.lat;
        final double? lng = store?.lng;
        if (lat != null && lng != null && context.mounted) {
          context.read<LocationCubit>().getAddress(lat, lng);
        }
        emit(ProfileSuccess(profileModel: newProfileModel));
      },
    );
  }

  /// Check if the current profile is complete
  bool isProfileComplete() {
    return ProfileValidator.isProfileComplete(profileModel);
  }

  /// Get list of missing fields in the current profile
  List<String> getMissingFields() {
    return ProfileValidator.getMissingFields(profileModel);
  }

  void addMarker(LatLng position) async {
    pickedPosition = position;
    emit(ProfileUpdate());

    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      currentAddress = '${place.street}';
      emit(ProfileUpdate());
    });
  }
}
