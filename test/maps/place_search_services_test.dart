// Offline tests for the nominatim place search behind the map search box.
//
// nominatim's usage policy is enforced by the shape of the request: it drops
// calls with no identifying User-Agent, so the header is part of the contract,
// not decoration. The parsing side covers its string-typed numbers and the
// [south, north, west, east] bounding box.
//
// run: flutter test test/maps/place_search_services_test.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:dinar_store/core/data/models/place_search_result.dart';
import 'package:dinar_store/core/data/services/place_search_services.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

///answers every request with [body] and records what was about to be sent
class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.body, {this.statusCode = 200});

  final Object body;
  final int statusCode;
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const List<Map<String, dynamic>> _hits = <Map<String, dynamic>>[
  <String, dynamic>{
    'place_id': 1,
    'lat': '33.3406',
    'lon': '44.4009',
    'display_name': 'شارع الرشيد، بغداد، العراق',
    'boundingbox': <String>['33.3300', '33.3500', '44.3900', '44.4100'],
  },
  <String, dynamic>{
    'place_id': 2,
    'lat': 'not-a-number',
    'lon': '44.4',
    'display_name': 'broken hit',
  },
  <String, dynamic>{
    'place_id': 3,
    'lat': '33.31',
    'lon': '44.36',
    'display_name': '',
  },
];

PlaceSearchServices _services(_StubAdapter adapter) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: kNominatimBaseUrl,
      headers: <String, dynamic>{'User-Agent': kNominatimUserAgent},
    ),
  )..httpClientAdapter = adapter;
  return PlaceSearchServices(dio: dio);
}

void main() {
  group('request shape', () {
    test('goes to nominatim /search with an identifying User-Agent', () async {
      final _StubAdapter adapter = _StubAdapter(const <dynamic>[]);
      await _services(adapter).search(query: 'بغداد');

      final RequestOptions sent = adapter.requests.single;
      expect(sent.uri.origin, 'https://nominatim.openstreetmap.org');
      expect(sent.uri.path, '/search');
      expect(sent.headers['User-Agent'], kNominatimUserAgent);
      expect(kNominatimUserAgent, contains('com.iraq.dinar'));
    });

    test('asks for json and passes the query through', () async {
      final _StubAdapter adapter = _StubAdapter(const <dynamic>[]);
      await _services(adapter).search(query: 'شارع الرشيد');

      final Map<String, String> params =
          adapter.requests.single.uri.queryParameters;
      expect(params['q'], 'شارع الرشيد');
      expect(params['format'], 'jsonv2');
      expect(params['limit'], '6');
      expect(params.containsKey('viewbox'), isFalse);

      ///a bias, never a fence — the user may well name somewhere off screen
      expect(params.containsKey('bounded'), isFalse);
    });

    test('sends the visible area as a lng,lat viewbox', () async {
      final _StubAdapter adapter = _StubAdapter(const <dynamic>[]);
      await _services(adapter).search(
        query: 'x',
        near: LatLngBounds(
          const LatLng(33.30, 44.35),
          const LatLng(33.34, 44.40),
        ),
      );

      final Map<String, String> params =
          adapter.requests.single.uri.queryParameters;
      expect(params['viewbox'], '44.35,33.34,44.4,33.3');
    });
  });

  group('response parsing', () {
    test('keeps drawable hits and drops the rest', () async {
      final _StubAdapter adapter = _StubAdapter(_hits);
      final result = await _services(adapter).search(query: 'x');

      final List<PlaceSearchResult> places = result.fold(
        (ServerFailure f) => fail('unexpected failure: ${f.errMessage}'),
        (List<PlaceSearchResult> places) => places,
      );

      expect(places, hasLength(1));
      final PlaceSearchResult place = places.single;
      expect(place.name, 'شارع الرشيد، بغداد، العراق');
      expect(place.point.latitude, closeTo(33.3406, 1e-9));
      expect(place.point.longitude, closeTo(44.4009, 1e-9));
    });

    test('reads the [south, north, west, east] bounding box', () async {
      final _StubAdapter adapter = _StubAdapter(_hits);
      final result = await _services(adapter).search(query: 'x');
      final LatLngBounds? bounds = result
          .getOrElse(() => const <PlaceSearchResult>[])
          .single
          .bounds;

      expect(bounds, isNotNull);
      expect(bounds!.south, closeTo(33.33, 1e-9));
      expect(bounds.north, closeTo(33.35, 1e-9));
      expect(bounds.west, closeTo(44.39, 1e-9));
      expect(bounds.east, closeTo(44.41, 1e-9));
    });

    test('a hit without a bounding box still parses', () {
      final PlaceSearchResult? place = PlaceSearchResult.fromNominatim(
        const <String, dynamic>{
          'lat': '33.31',
          'lon': '44.36',
          'display_name': 'somewhere',
        },
      );
      expect(place, isNotNull);
      expect(place!.bounds, isNull);
    });

    test('a non-list body is a failure, not a crash', () async {
      final _StubAdapter adapter = _StubAdapter(
        const <String, dynamic>{'error': 'Unable to geocode'},
      );
      final result = await _services(adapter).search(query: 'x');
      expect(result.isLeft(), isTrue);
    });

    test('an http error becomes a ServerFailure', () async {
      final _StubAdapter adapter = _StubAdapter(
        const <String, dynamic>{'error': 'Too many requests'},
        statusCode: 429,
      );
      final result = await _services(adapter).search(query: 'x');
      expect(result.isLeft(), isTrue);
    });
  });
}
