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
  ProfileFaliuer({required this.errMessage});
}

final class ProfileUpdate extends ProfileState {}