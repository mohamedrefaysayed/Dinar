part of 'store_data_cubit.dart';

sealed class StoreDataState {}

final class StoreDataInitial extends StoreDataState {}

final class StoreDataLoading extends StoreDataState {}

final class StoreDataSuccess extends StoreDataState {}

final class StoreDataFailure extends StoreDataState {
  final String errMessage;

  StoreDataFailure({required this.errMessage});
}

final class UpdateLocationLoading extends StoreDataState {}

final class UpdateLocationSuccess extends StoreDataState {}

final class UpdateLocationFailure extends StoreDataState {
  final String errMessage;

  UpdateLocationFailure({required this.errMessage});
}

final class UpdateDataLoading extends StoreDataState {}

final class UpdateDataSuccess extends StoreDataState {}

final class UpdateDataFailure extends StoreDataState {
  final String errMessage;

  UpdateDataFailure({required this.errMessage});
}
