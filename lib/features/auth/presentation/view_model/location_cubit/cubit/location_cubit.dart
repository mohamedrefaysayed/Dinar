// ignore_for_file: use_build_context_synchronously

import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/data/services/locatio_service.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required LocationServices locationServices})
      : super(LocationInitial()) {
    _locationServices = locationServices;
  }
  late LocationServices _locationServices;

  static Position? currentPosition;

  Future getCurrentLocation({required BuildContext context}) async {
    try {
      emit(LocationLoading());
      bool locationsIsGranted = await Permission.location.status.isGranted;
      if (!locationsIsGranted) {
        locationsIsGranted = await Permission.location.request().isDenied;
      } else {
        bool locationsIsGranted =
            await Permission.locationAlways.status.isGranted;
        if (!locationsIsGranted) {
          locationsIsGranted =
              await Permission.locationAlways.request().isGranted;
        }
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.

      currentPosition = await Geolocator.getCurrentPosition();
      emit(LocationSuccess());
    } catch (error) {
      emit(LocationFailuer());
      ScaffoldMessenger.of(context).showSnackBar(
        messageSnackBar(message: "أفتح الموقع"),
      );
    }
  }

  Future<void> getAddress(double lat, double lng) async {
    emit(LocationLoading());
    Either<ServerFailure, Placemark> addressResult =
        await _locationServices.convertPositionToAddress(lat: lat, lng: lng);

    addressResult.fold(
      //error
      (serverFailure) {
        emit(
          AddressFailuer(errorMessage: serverFailure.errMessage),
        );
      },
      //success
      (address) {
        emit(
          AddressSuccess(
            locationData: {
              'lat': lat,
              'lng': lng,
              'address': address,
            },
          ),
        );
      },
    );
  }
}
