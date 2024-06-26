import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/features/auth/data/services/log_in_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';

part 'log_in_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit({
    required LogInServices logInServices,
  }) : super(LogInInitial()) {
    _logInServices = logInServices;
  }

  late LogInServices _logInServices;

  static PhoneNumber? phoneNumber;
  static String? code;
  static String? fakeCode;

  Future<void> register() async {
    emit(SendCodeLoading());

    Either<ServerFailure, Map<String, dynamic>> result =
        await _logInServices.register(
      countryCode: phoneNumber!.countryCode,
      phoneNumber: phoneNumber!.number,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          LogInFailure(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (data) async {
        fakeCode = data['verificationCode'].toString();
        emit(SendCodeSuccess(message: data['message']));
      },
    );
  }

  Future<void> sendVerficationCode() async {
    emit(VerficationLoading());
    Either<ServerFailure, Map<String, dynamic>> result =
        await _logInServices.sendVCode(
      code: code!,
    );

    result.fold(
      //error
      (serverFailure) {
        emit(
          LogInFailure(errMessage: serverFailure.errMessage),
        );
      },
      //success
      (data) async {
        await _logInServices.storeTokenInSecureStorage(token: data['token']);

        emit(VerficationSuccess(firstTime: data['user']['store'] == null));
      },
    );
  }
}
