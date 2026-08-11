import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/core/utils/genrall.dart';
import 'package:dinar_store/features/auth/presentation/view/login_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Signs the user out the moment the backend rejects their token.
///
/// Any authenticated request can come back `401 {"message":"Unauthenticated"}`
/// while the app is in use: the token expired, was revoked, or — right after
/// the api base url changed — belongs to the retired backend. Without this the
/// dead token is replayed on every later call and the user is stuck seeing
/// "Unauthenticated". This clears the session once and drops them on the login
/// screen, from where a fresh sign in issues a valid token.
///
/// The error still flows through to each caller afterwards, so their existing
/// [ServerFailure] handling (snackbars, retry states) is unchanged.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  ///guards a burst of parallel requests all 401ing at once from each trying to
  ///push the login screen. reset shortly after so a later session (after the
  ///user signs back in and its token expires again) can still be caught
  static bool _loggingOut = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (shouldSignOut(err)) {
      _logOut();
    }

    ///keep the error flowing so every service still resolves its own
    ///Either/ServerFailure exactly as before
    handler.next(err);
  }

  ///true only when the backend rejected a request that actually carried a
  ///bearer token. a 401 from login/verify (which send no token) is a wrong
  ///code, not an expired session, and must not bounce the user out mid sign in
  @visibleForTesting
  static bool shouldSignOut(DioException err) {
    if (err.response?.statusCode != 401) return false;
    if (AppCubit.token == null) return false;

    final Object? auth = err.requestOptions.headers['Authorization'];
    return auth is String && auth.startsWith('Bearer ') && auth.length > 7;
  }

  void _logOut() {
    if (_loggingOut) return;
    _loggingOut = true;

    AppCubit.token = null;

    ///best effort: a missing key still leaves us signed out
    _secureStorage.delete(key: kSecureStorageKey).catchError((_) {});

    final NavigatorState? navigator = navigatorKey.currentState;
    navigator?.pushNamedAndRemoveUntil(LogInView.id, (route) => false);

    ///let the burst settle, then re-arm for a future session
    Future<void>.delayed(
      const Duration(seconds: 1),
      () => _loggingOut = false,
    );
  }
}
