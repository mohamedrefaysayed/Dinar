// Offline regression tests for the "old users land on the registration form
// and see Unauthenticated" bug after the api base url changed.
//
// An old install still holds a bearer token issued by the retired backend.
// The new backend (https://new.dinnari.com/api/) answers GET /get-user for
// that token with 401 {"message":"Unauthenticated"}. The splash flow must be
// able to tell that rejected token apart from a merely incomplete profile, so
// ServerFailure has to carry the http status code through. Before the fix the
// status was dropped, the null profile read as "incomplete", and the user was
// pushed to the store-registration form where every save 401s again.
//
// run: flutter test test/api/unauthenticated_status_test.dart

import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _badResponse(int statusCode, dynamic body) {
  final RequestOptions request = RequestOptions(path: 'get-user');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: statusCode,
      data: body,
    ),
  );
}

void main() {
  group('ServerFailure surfaces the http status behind a failure', () {
    test('a rejected token 401 carries its status code and message', () {
      final ServerFailure failure = ServerFailure.fromDioException(
        dioException: _badResponse(401, <String, dynamic>{
          'message': 'Unauthenticated.',
        }),
      );

      // the splash flow keys off this: 401 => wipe the dead token, go to login
      expect(failure.statusCode, 401);
      expect(failure.errMessage, 'Unauthenticated.');
    });

    test('a 403 is also flagged as an auth failure', () {
      final ServerFailure failure = ServerFailure.fromDioException(
        dioException: _badResponse(403, <String, dynamic>{
          'message': 'Unauthenticated.',
        }),
      );

      expect(failure.statusCode, 403);
    });

    test('a server error keeps its status without masquerading as an auth one',
        () {
      final ServerFailure failure = ServerFailure.fromDioException(
        dioException: _badResponse(500, <String, dynamic>{}),
      );

      expect(failure.statusCode, 500);
      expect(failure.errMessage, 'Internal Server Error');
    });

    test('a transport error (no response) reports a null status', () {
      final ServerFailure failure = ServerFailure.fromDioException(
        dioException: DioException(
          requestOptions: RequestOptions(path: 'get-user'),
          type: DioExceptionType.connectionError,
        ),
      );

      // null status => not an auth failure => the token is left in place
      expect(failure.statusCode, isNull);
    });
  });
}
