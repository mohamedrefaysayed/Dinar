// Offline tests for the shape of the requests DioHelper sends.
//
// This is the regression test for the empty home screen on
// https://new.dinnari.com/api/ : the server answers any GET that carries a
// body with a 403, and DioHelper used to send `data: body ?? {}` on every GET,
// so companies, categories, ads, cart, orders and the profile all failed
// while the same urls returned 200 from curl.
//
// run: flutter test test/api/get_request_body_test.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

///records what dio was about to put on the wire instead of sending it
class _RecordingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{'ok': true}),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late _RecordingAdapter adapter;
  late DioHelper dioHelper;

  setUp(() {
    adapter = _RecordingAdapter();
    dioHelper = DioHelper();
    dioHelper.dio.httpClientAdapter = adapter;
  });

  group('GET requests', () {
    test('carry no body, the server 403s the ones that do', () async {
      await dioHelper.getRequest(endPoint: 'companies');

      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.data, isNull);
    });

    test('the void variant carries no body either', () async {
      await dioHelper.getRequestWithoutReturn(endPoint: 'categories');

      expect(adapter.requests.single.data, isNull);
    });

    test('an explicit body is still forwarded when a caller asks for one',
        () async {
      await dioHelper.getRequest(
        endPoint: 'products',
        body: <String, dynamic>{'keyword': 'x'},
      );

      expect(adapter.requests.single.data, <String, dynamic>{'keyword': 'x'});
    });

    test('query parameters are untouched by the body change', () async {
      await dioHelper.getRequest(
        endPoint: 'products',
        queryParameters: <String, dynamic>{'page': 2},
      );

      expect(adapter.requests.single.queryParameters, <String, dynamic>{
        'page': 2,
      });
      expect(adapter.requests.single.data, isNull);
    });
  });

  group('the authorization header', () {
    test('is sent when a real token is supplied', () async {
      await dioHelper.getRequest(endPoint: 'cart', token: 'abc123');

      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer abc123',
      );
    });

    ///the public cubits pass `AppCubit.token ?? ''` because the services
    ///declare a non nullable token, so an empty string has to mean "anonymous"
    ///rather than a literal "Bearer " header
    test('is omitted for the empty string a signed out user produces',
        () async {
      await dioHelper.getRequest(endPoint: 'companies', token: '');

      expect(adapter.requests.single.headers.containsKey('Authorization'),
          isFalse);
    });

    test('is omitted when no token is supplied at all', () async {
      await dioHelper.getRequest(endPoint: 'companies');

      expect(adapter.requests.single.headers.containsKey('Authorization'),
          isFalse);
    });

    test('an empty token on a post is treated as anonymous too', () async {
      await dioHelper.postRequest(
        endPoint: 'search',
        body: <String, dynamic>{'keyword': 'x'},
        token: '',
      );

      expect(adapter.requests.single.headers.containsKey('Authorization'),
          isFalse);
    });
  });
}
