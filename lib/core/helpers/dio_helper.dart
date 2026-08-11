import 'package:dinar_store/core/helpers/auth_interceptor.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:requests_inspector/requests_inspector.dart';

class DioHelper {
  DioHelper({Dio? dio}) {
    if (dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: normalizeAppDomain(appDomain),
        ),
      );

      ///feed every request/response/error to the in-app inspector (shake or
      ///long-press to open) when [kInspectorEnabled] — always in debug, and in
      ///release only under --dart-define=INSPECTOR=true. off in store releases
      if (kInspectorEnabled) {
        _dio.interceptors.add(RequestsInspectorInterceptor());
      }

      ///a token the backend rejects (expired, revoked, or issued by the retired
      ///domain) should sign the user out instead of failing every later call
      _dio.interceptors.add(AuthInterceptor());
    } else {
      ///injected client (tests): left untouched so it stays hermetic
      _dio = dio;
    }
  }

  late Dio _dio;

  ///the configured client, so tests can assert the resolved base url and
  ///swap in an adapter instead of reaching the network
  Dio get dio => _dio;

  /// http get request
  Future<Map<String, dynamic>> getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
    Object? body,
  }) async {
    Map<String, dynamic>? headers;

    if (token != null && token.isNotEmpty) {
      headers = {'Authorization': 'Bearer $token'};
    }
    Response response = await _dio.get(
      endPoint,

      ///never send an empty body on a GET. the server rejects any GET that
      ///carries one with a 403, which used to fail every read in the app
      data: body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );
    return response.data ?? {};
  }

  /// http get request
  Future<void> getRequestWithoutReturn({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
    Object? body,
  }) async {
    Map<String, dynamic>? headers;

    if (token != null && token.isNotEmpty) {
      headers = {'Authorization': 'Bearer $token'};
    }
    await _dio.get(
      endPoint,

      ///see getRequest: a GET carrying a body is answered with a 403
      data: body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );
  }

  ///http post request
  Future<Map<String, dynamic>> postRequest({
    required Object body,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    Response response = await _dio.post(
      endPoint,
      data: body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }

  ///http delete request
  Future<Map<String, dynamic>> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    Response response = await _dio.delete(
      endPoint,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }

  ///http patch request
  Future<Map<String, dynamic>> patchRequest({
    required Object body,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    Response response = await _dio.patch(
      endPoint,
      data: body,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }
}
