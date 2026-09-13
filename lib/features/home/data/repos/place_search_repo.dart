import 'package:dartz/dartz.dart';
import 'package:dinar_store/core/data/models/place_search_result.dart';
import 'package:dinar_store/core/errors/server_failure.dart';
import 'package:flutter_map/flutter_map.dart';

abstract class PlaceSearchRepo {
  /// Places matching the free-text [query], best match first. [near] biases
  /// the ranking towards an area — the part of the map on screen — without
  /// excluding hits outside it.
  Future<Either<ServerFailure, List<PlaceSearchResult>>> search({
    required String query,
    LatLngBounds? near,
  });
}
