// Offline tests for the api base url and the image url builder.
//
// These are the regression tests for the migration to
// https://new.dinnari.com/api/ : dio joins the base url and the endpoint by
// plain string concatenation, so a base url without a trailing slash turns
// every request into a 404, and the image paths of the new backend no longer
// need the storage/ prefix the retired one required.
//
// run: flutter test test/api/api_url_test.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

const String kOldDomain = 'https://dinnari.com/public/index.php/api/';

///records the absolute url dio resolved instead of hitting the network
class _RecordingAdapter implements HttpClientAdapter {
  final List<Uri> requestedUris = <Uri>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedUris.add(options.uri);
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

///every endpoint the app calls, as (method, endPoint) pairs
const List<List<String>> kEndPoints = <List<String>>[
  <String>['POST', 'register'],
  <String>['POST', 'verify'],
  <String>['POST', 'store'],
  <String>['POST', 'store/7'],
  <String>['POST', 'delete_account'],
  <String>['GET', 'get-user'],
  <String>['GET', 'ads'],
  <String>['GET', 'categories'],
  <String>['GET', 'categories/show_by_parent/1'],
  <String>['GET', 'companies'],
  <String>['GET', 'products/show_by_category/104'],
  <String>['GET', 'products/show_by_company/1'],
  <String>['GET', 'products/508'],
  <String>['POST', 'search'],
  <String>['GET', 'cart'],
  <String>['POST', 'cart'],
  <String>['POST', 'cart/3'],
  <String>['GET', 'orders'],
  <String>['POST', 'orders'],
  <String>['GET', 'orders/9'],
  <String>['POST', 'orders/9'],
  <String>['POST', 'orders/get_agent_orders'],
  <String>['GET', 'agents/change_status'],
];

void main() {
  final String originalDomain = appDomain;

  tearDown(() => appDomain = originalDomain);

  group('normalizeAppDomain', () {
    test('appends the trailing slash dio needs', () {
      expect(
        normalizeAppDomain('https://new.dinnari.com/api'),
        'https://new.dinnari.com/api/',
      );
    });

    test('keeps a domain that already ends with a slash untouched', () {
      expect(
        normalizeAppDomain('https://new.dinnari.com/api/'),
        'https://new.dinnari.com/api/',
      );
    });

    test('trims surrounding whitespace', () {
      expect(
        normalizeAppDomain('  https://new.dinnari.com/api  '),
        'https://new.dinnari.com/api/',
      );
    });

    test('falls back when firestore or the cache has no usable value', () {
      expect(normalizeAppDomain(null), kDefaultAppDomain);
      expect(normalizeAppDomain(''), kDefaultAppDomain);
      expect(normalizeAppDomain('   '), kDefaultAppDomain);
      expect(normalizeAppDomain(42), kDefaultAppDomain);
      expect(
        normalizeAppDomain(null, fallback: kOldDomain),
        kOldDomain,
      );
    });

    test('the shipped default points at the new backend', () {
      expect(kDefaultAppDomain, 'https://new.dinnari.com/api/');
      expect(kDefaultAppDomain.endsWith('/'), isTrue);
    });
  });

  group('DioHelper base url', () {
    test('normalizes whatever appDomain holds at construction time', () {
      appDomain = 'https://new.dinnari.com/api';
      expect(DioHelper().dio.options.baseUrl, 'https://new.dinnari.com/api/');
    });

    test('resolves every endpoint to a valid absolute url', () async {
      appDomain = kDefaultAppDomain;
      final _RecordingAdapter adapter = _RecordingAdapter();
      final DioHelper dioHelper = DioHelper();
      dioHelper.dio.httpClientAdapter = adapter;

      for (final List<String> endPoint in kEndPoints) {
        if (endPoint.first == 'GET') {
          await dioHelper.getRequest(endPoint: endPoint.last);
        } else {
          await dioHelper.postRequest(endPoint: endPoint.last, body: {});
        }
      }

      expect(adapter.requestedUris.length, kEndPoints.length);
      for (int i = 0; i < kEndPoints.length; i++) {
        final Uri uri = adapter.requestedUris[i];
        expect(
          uri.toString(),
          'https://new.dinnari.com/api/${kEndPoints[i].last}',
          reason: '${kEndPoints[i].first} ${kEndPoints[i].last} resolved wrong',
        );
        expect(uri.path, startsWith('/api/'));
      }
    });

    test(
        'a domain saved without a trailing slash still resolves, '
        'it used to produce https://new.dinnari.com/apiregister', () async {
      appDomain = normalizeAppDomain('https://new.dinnari.com/api');
      final _RecordingAdapter adapter = _RecordingAdapter();
      final DioHelper dioHelper = DioHelper();
      dioHelper.dio.httpClientAdapter = adapter;

      await dioHelper.postRequest(endPoint: 'register', body: {});

      expect(
        adapter.requestedUris.single.toString(),
        'https://new.dinnari.com/api/register',
      );
    });
  });

  group('appAssetsDomain', () {
    test('drops the api segment of the current backend', () {
      appDomain = kDefaultAppDomain;
      expect(appAssetsDomain, 'https://new.dinnari.com/');
    });

    test('keeps serving the retired backend from public/storage', () {
      appDomain = kOldDomain;
      expect(appAssetsDomain, 'https://dinnari.com/public/storage/');
    });
  });

  group('buildImageUrl on the new backend', () {
    setUp(() => appDomain = kDefaultAppDomain);

    test('category, product and search images keep their storage prefix', () {
      expect(
        buildImageUrl('/storage/images/2TQNZLj2bAd8HSPyKRn2bVTPe5u4adcx.jpg'),
        'https://new.dinnari.com/storage/images/2TQNZLj2bAd8HSPyKRn2bVTPe5u4adcx.jpg',
      );
    });

    test('ad images are served from the site root without a storage prefix',
        () {
      expect(
        buildImageUrl('images/20260726034311.jpg'),
        'https://new.dinnari.com/images/20260726034311.jpg',
      );
    });

    test('the doubled images/images/ company logos are repaired', () {
      // the backend returns /storage/images/images/<file> for all company
      // logos, which 404s, the file itself sits at /storage/images/<file>
      expect(
        buildImageUrl('/storage/images/images/GU6o7vr9f7RD8IMptPeRM4gpw.jpg'),
        'https://new.dinnari.com/storage/images/GU6o7vr9f7RD8IMptPeRM4gpw.jpg',
      );
    });

    test('an absolute url from the api is passed through', () {
      expect(
        buildImageUrl('https://new.dinnari.com/images/20260726034311.jpg'),
        'https://new.dinnari.com/images/20260726034311.jpg',
      );
    });

    test('a null or empty path yields an empty url instead of throwing', () {
      expect(buildImageUrl(null), '');
      expect(buildImageUrl(''), '');
      expect(buildImageUrl('   '), '');
    });

    test('never produces a double slash', () {
      for (final String path in <String>[
        '/storage/images/a.jpg',
        'images/a.jpg',
        '/images/a.jpg',
      ]) {
        final String url = buildImageUrl(path);
        expect(url.substring('https://'.length), isNot(contains('//')),
            reason: '$path produced $url');
      }
    });
  });

  group('buildImageUrl on the retired backend', () {
    setUp(() => appDomain = kOldDomain);

    test('bare paths still get the storage prefix they needed', () {
      expect(
        buildImageUrl('images/p63BsoEmFbSXeY95wiqo6t8bOyLyku7pY2ky.webp'),
        'https://dinnari.com/public/storage/images/p63BsoEmFbSXeY95wiqo6t8bOyLyku7pY2ky.webp',
      );
    });

    test('a path that already carries storage/ is not prefixed twice', () {
      expect(
        buildImageUrl('/storage/images/a.jpg'),
        'https://dinnari.com/public/storage/images/a.jpg',
      );
    });
  });
}
