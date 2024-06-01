part of 'log_out_cubit.dart';

sealed class LogOutState {}

final class LogOutInitial extends LogOutState {}

final class LogOutLoading extends LogOutState {}

final class DeleteAccountLoading extends LogOutState {}

final class LogOutSuccess extends LogOutState {}

final class DeleteAccountSuccess extends LogOutState {}

final class LogOutFailure extends LogOutState {
  final String errMessage;

  LogOutFailure({required this.errMessage});
}

final class DeleteAccountFailure extends LogOutState {
  final String errMessage;

  DeleteAccountFailure({required this.errMessage});
}
