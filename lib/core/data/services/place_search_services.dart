import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/data/models/place_search_result.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:dinar_store/core/widgets/maps/app_map.dart';
import 'package:dinar_store/features/home/data/repos/place_search_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_map/flutter_map.dart';

/// Where place searches go: nominatim, OpenStreetMap's own geocoder.
const String kNominatimBaseUrl = 'https://nominatim.openstreetmap.org';

/// Nominatim refuses requests that do not identify the app sending them.
const String kNominatimUserAgent = 'dinar_store ($kOsmUserAgentPackageName)';

/// Free-text place search through nominatim.
///
/// Keyless like the map tiles, and with the same strings attached: every
/// request must carry a User-Agent naming the app, the service allows one
/// request a second and forbids autocomplete. So the search box only calls
/// this on submit — never on every keystroke.
///
/// It gets its own [Dio] rather than going through [DioHelper]: that client is
/// bound to the store's api and carries the auth interceptor, and neither the
/// backend url nor a bearer token belongs on a request to a third party.
class PlaceSearchServices implements PlaceSearchRepo {
  PlaceSearchServices({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: kNominatimBaseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
                headers: <String, dynamic>{
                  'User-Agent': kNominatimUserAgent,

                  ///arabic labels where osm has them, english otherwise
                  'Accept-Language': 'ar,en;q=0.8',
                },
              ),
            );

  final Dio _dio;

  @override
  Future<Either<ServerFailure, List<PlaceSearchResult>>> search({
    required String query,
    LatLngBounds? near,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        '/search',
        queryParameters: <String, dynamic>{
          'q': query,
          'format': 'jsonv2',
          'limit': 6,

          ///viewbox is lng,lat pairs of any two opposite corners. Without
          ///bounded=1 it only ranks hits inside the box first, so a place the
          ///user names outside the current view is still found
          if (near != null)
            'viewbox': '${near.west},${near.north},${near.east},${near.south}',
        },
      );

      final dynamic data = response.data;
      if (data is! List) {
        return left(ServerFailure(errMessage: 'Unexpected search response'));
      }

      return right(
        data
            .whereType<Map>()
            .map((Map hit) => PlaceSearchResult.fromNominatim(
                  Map<String, dynamic>.from(hit),
                ))
            .whereType<PlaceSearchResult>()
            .toList(),
      );
    } on DioException catch (e) {
      return left(ServerFailure.fromDioException(dioException: e));
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
