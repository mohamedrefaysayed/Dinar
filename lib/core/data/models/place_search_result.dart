import 'package:dinar_store/core/widgets/maps/app_map.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// One hit from a place search: what to call it and where it is.
class PlaceSearchResult {
  const PlaceSearchResult({
    required this.name,
    required this.point,
    this.bounds,
  });

  /// the full label the geocoder gives the place ("شارع الرشيد، بغداد، العراق")
  final String name;

  final LatLng point;

  /// the area the place covers, when the geocoder reports one. A city gets the
  /// camera fitted to it; a shop's box is a few metres wide and fits to the
  /// same view a plain move would
  final LatLngBounds? bounds;

  /// A nominatim `/search` hit, or null when it has no drawable coordinate.
  ///
  /// nominatim sends every number as a string ("33.31", not 33.31) and its
  /// `boundingbox` as [south, north, west, east], all strings too.
  static PlaceSearchResult? fromNominatim(Map<String, dynamic> json) {
    final LatLng? point = safeLatLng(
      _parse(json['lat']),
      _parse(json['lon']),
    );
    if (point == null) return null;

    final String name = '${json['display_name'] ?? json['name'] ?? ''}'.trim();
    if (name.isEmpty) return null;

    LatLngBounds? bounds;
    final dynamic box = json['boundingbox'];
    if (box is List && box.length == 4) {
      final LatLng? southWest = safeLatLng(_parse(box[0]), _parse(box[2]));
      final LatLng? northEast = safeLatLng(_parse(box[1]), _parse(box[3]));
      if (southWest != null && northEast != null) {
        bounds = LatLngBounds(southWest, northEast);
      }
    }

    return PlaceSearchResult(name: name, point: point, bounds: bounds);
  }

  static double? _parse(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
