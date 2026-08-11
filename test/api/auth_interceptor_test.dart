// Offline tests for the global auto sign out on a rejected token.
//
// AuthInterceptor watches every authenticated request. When the backend answers
// 401 "Unauthenticated" for a request that carried a bearer token, the token is
// dead (expired, revoked, or issued by the retired domain after the base url
// changed) and the user is signed out. These tests pin down exactly which 401s
// count, so a wrong verification code during login never bounces the user out.
//
// run: flutter test test/api/auth_interceptor_test.dart

import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/helpers/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _error({
  required int statusCode,
  Map<String, dynamic>? headers,
}) {
  final RequestOptions request = RequestOptions(
    path: 'get-user',
    headers: headers ?? <String, dynamic>{},
  );
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: statusCode,
    ),
  );
}

void main() {
  group('AuthInterceptor.shouldSignOut', () {
    tearDown(() => AppCubit.token = null);

    test('a 401 on a request that carried a bearer token signs the user out',
        () {
      AppCubit.token = 'a-real-token';

      final DioException err = _error(
        statusCode: 401,
        headers: <String, dynamic>{'Authorization': 'Bearer a-real-token'},
      );

      expect(AuthInterceptor.shouldSignOut(err), isTrue);
    });

    test('a 401 during login (no token attached) is left alone', () {
      // the user is signing in, so there is no session to end. wrong-code 401s
      // on /verify must stay with the login screen, not wipe anything
      AppCubit.token = null;

      final DioException err = _error(statusCode: 401);

      expect(AuthInterceptor.shouldSignOut(err), isFalse);
    });

    test('a 401 with no Authorization header does not sign out', () {
      AppCubit.token = 'a-real-token';

      final DioException err = _error(statusCode: 401);

      expect(AuthInterceptor.shouldSignOut(err), isFalse);
    });

    test('a non-401 error never signs the user out', () {
      AppCubit.token = 'a-real-token';

      for (final int status in <int>[400, 403, 404, 422, 500]) {
        final DioException err = _error(
          statusCode: status,
          headers: <String, dynamic>{'Authorization': 'Bearer a-real-token'},
        );
        expect(
          AuthInterceptor.shouldSignOut(err),
          isFalse,
          reason: 'status $status should not trigger sign out',
        );
      }
    });

    test('a transport error with no response never signs out', () {
      AppCubit.token = 'a-real-token';

      final DioException err = DioException(
        requestOptions: RequestOptions(
          path: 'get-user',
          headers: <String, dynamic>{'Authorization': 'Bearer a-real-token'},
        ),
        type: DioExceptionType.connectionError,
      );

      expect(AuthInterceptor.shouldSignOut(err), isFalse);
    });
  });
}
