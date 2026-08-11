part of 'profile_cubit.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final ProfileModel profileModel;
  ProfileSuccess({required this.profileModel});
}

final class LocationSuccess extends ProfileState {
  final Map<String, dynamic> locationData;
  LocationSuccess({required this.locationData});
}

final class ProfileFaliuer extends ProfileState {
  final String errMessage;

  ///the http status of the failed profile fetch, if any. 401/403 means the
  ///stored token was rejected (e.g. it belongs to the retired backend after
  ///the base url changed) rather than the profile being incomplete
  final int? statusCode;
  ProfileFaliuer({required this.errMessage, this.statusCode});
}

final class ProfileUpdate extends ProfileState {}