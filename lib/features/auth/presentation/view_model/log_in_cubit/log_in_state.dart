part of 'log_in_cubit.dart';

@immutable
sealed class LogInState {}

final class LogInInitial extends LogInState {}

final class SendCodeLoading extends LogInState {}

final class VerficationLoading extends LogInState {}

final class SendCodeSuccess extends LogInState {
  final String message;
  SendCodeSuccess({required this.message});
}

final class VerficationSuccess extends LogInState {
  final bool firstTime;
  VerficationSuccess({required this.firstTime });
}

final class LogInFailure extends LogInState {
  final String errMessage;

  LogInFailure({required this.errMessage});
}
