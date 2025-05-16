part of 'location_cubit.dart';

sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationSuccess extends LocationState {
  Position position;
  LocationSuccess({required this.position});
}

final class AddressSuccess extends LocationState {
  Map<String, dynamic> locationData;
  AddressSuccess({required this.locationData});
}

final class AddressFailuer extends LocationState {
  String errorMessage;
  AddressFailuer({required this.errorMessage});
}

final class LocationFailure extends LocationState {}
