import 'package:dio/dio.dart';

class ServerFailure {
  String errMessage;

  ///the http status code behind the failure, when there is one (badResponse).
  ///null for transport errors (timeouts, no connection) that never reached a
  ///response. callers use it to tell an expired/rejected token (401/403) apart
  ///from a merely incomplete profile
  final int? statusCode;

  ServerFailure({required this.errMessage, this.statusCode});

  factory ServerFailure._badResponse({
    required int statusCode,
    required dynamic response,
  }) {
    if (statusCode == 400 ||
        statusCode == 401 ||
        statusCode == 403 ||
        statusCode == 422) {
      return ServerFailure(
        errMessage: _readErrorMessage(response) ??
            'Oops unexpected error occurred, Please try again',
        statusCode: statusCode,
      );
    }else if (statusCode == 500){
      return ServerFailure(errMessage: 'Internal Server Error', statusCode: statusCode);
    } else if (statusCode == 404) {
      return ServerFailure(errMessage: '404 Page Not Found', statusCode: statusCode);
    } else {
      return ServerFailure(
        errMessage: 'Oops unexpected error occurred, Please try again',
        statusCode: statusCode,
      );
    }
  }

  ///pull a readable message out of an error body.
  ///the backend answers with 'message' ({"message":"Unauthenticated"}),
  ///with 'error' ({"error":"كود التفعيل خاطيء"}) or with laravel's validation
  ///bag ({"errors":{"phone":["..."]}}), and old code assumed 'message' always
  ///existed, which turned a wrong verification code into a raw dart error
  static String? _readErrorMessage(dynamic response) {
    if (response is String) {
      return response.trim().isEmpty ? null : response;
    }
    if (response is! Map) return null;

    for (final String key in const ['message', 'error', 'msg']) {
      final dynamic value = response[key];
      if (value is String && value.trim().isNotEmpty) return value;
      if (value is List && value.isNotEmpty) return value.first.toString();
    }

    final dynamic errors = response['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final dynamic first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
      if (first is String && first.trim().isNotEmpty) return first;
    }
    if (errors is List && errors.isNotEmpty) return errors.first.toString();

    return null;
  }

  factory ServerFailure.fromDioException({
    required DioException dioException,
  }) {
    switch (dioException.type) {
      //connection between client and server timeout
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          errMessage: 'Server connection timeout. Please try again.',
        );
      //the client sends data to the server,
      //but the server does not respond within the specified time limit
      case DioExceptionType.sendTimeout:
        return ServerFailure(
          errMessage:
              'Sending data to server takes too much time, check your internet connection.',
        );
      //the client is waiting to receive data from the server,
      // but the server does not send a response within the specified time limit
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          errMessage:
              'Receiving data from server takes too much time, check your internet connection.',
        );
      //there is an error in the network
      case DioExceptionType.connectionError:
        return ServerFailure(errMessage: 'No internet connection');
      //the request cancelled by the user
      case DioExceptionType.cancel:
        return ServerFailure(
            errMessage: 'Request cancelled. Please try again.');
      //the error have a response
      case DioExceptionType.badResponse:
        return ServerFailure._badResponse(
          statusCode: dioException.response?.statusCode ?? 0,
          response: dioException.response?.data,
        );
      //there is a security or privacy issues
      case DioExceptionType.badCertificate:
        return ServerFailure(
          errMessage:
              'Your connection is not private. The server\'s SSL certificate is not valid. Proceed with caution',
        );
      //the default errMessage
      default:
        return ServerFailure(
          errMessage: 'Oops unexpected error occurred, Please try again',
        );
    }
  }
}
