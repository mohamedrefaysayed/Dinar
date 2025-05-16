// ignore_for_file: use_build_context_synchronously

import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/data/services/locatio_service.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({required LocationServices locationServices})
      : super(LocationInitial()) {
    _locationServices = locationServices;
  }
  late LocationServices _locationServices;

  static Position? currentPosition;

  Future<void> getCurrentLocation({required BuildContext context}) async {
    emit(LocationLoading());

    // Check location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, show guidance to open app settings
      emit(LocationFailure());
      context.showMessageSnackBar(
        message:
            "Location permissions permanently denied. Please enable in app settings.",
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      // Request permissions if denied
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // User denied the request
        emit(LocationFailure());
        context.showMessageSnackBar(
          message: "Location permissions are required to use this feature.",
        );
        return;
      }
    }

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      emit(LocationSuccess(position: position));
    } catch (error) {
      emit(LocationFailure());
      context.showMessageSnackBar(
        message:
            "Failed to get location. Please ensure location services are enabled.",
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

  String getAddressString(currentLocationData) {
    List<String> components = [
      currentLocationData['address'].name ?? '',
      currentLocationData['address'].thoroughfare ?? '',
      currentLocationData['address'].locality ?? '',
      currentLocationData['address'].administrativeArea ?? '',
      currentLocationData['address'].country ?? '',
    ];

    // Filter out empty strings and join with commas
    String address =
        components.where((component) => component.isNotEmpty).join(', ');
    return address;
  }
}
