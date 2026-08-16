import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shared pieces for every map in the app.
///
/// The app renders its maps with OpenStreetMap raster tiles through
/// flutter_map instead of the Google Maps SDK: the tiles are free and need no
/// API key, no billing account and no per-platform SDK. The buttons that hand
/// a location off to the Google Maps *app* for turn-by-turn navigation are
/// untouched — they are plain url_launcher links and cost nothing.

/// The standard OpenStreetMap raster tile server.
const String kOsmTileUrlTemplate =
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

/// The OSM tile usage policy requires a valid identifying User-Agent.
/// flutter_map turns this into 'flutter_map (com.iraq.dinar)' on every tile
/// request, so the traffic is attributable to this app.
const String kOsmUserAgentPackageName = 'com.iraq.dinar';

/// tile.openstreetmap.org serves tiles down to z19; asking for more returns
/// 404s and a grey map rather than a sharper one.
const double kOsmMaxZoom = 19;

/// A map that is only there to be looked at — what google maps' liteModeEnabled
/// gave us. Clearing the gesture flags alone is not enough: flutter_map's
/// keyboard control defaults to autofocus and arrow-key panning, so a "static"
/// preview would still grab focus from the screen around it and scroll away
/// from the location it exists to show.
const InteractionOptions kPreviewInteractionOptions = InteractionOptions(
  flags: InteractiveFlag.none,
  keyboardOptions: KeyboardOptions.disabled(),
);

/// A map the user picks a point on. Panning and zooming stay, rotation goes:
/// the google map kept north up, and a rotated map makes an unfamiliar
/// neighbourhood harder to read, not easier.
const InteractionOptions kPickerInteractionOptions = InteractionOptions(
  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  keyboardOptions: KeyboardOptions.disabled(),
);

/// Where a map opens when it has nothing usable to centre on. Baghdad, the
/// app's own market — only ever reached when stored coordinates are corrupt.
const LatLng kFallbackMapCenter = LatLng(33.3152, 44.3661);

/// A coordinate the map can actually draw, or null when the values are not a
/// usable point.
///
/// Google's LatLng clamped whatever it was handed, so a bad coordinate from the
/// api merely drew a pin in the wrong place. latlong2 takes any double as-is
/// and the marker layer throws on a non-finite point, so the same bad value
/// would now take down the whole screen — note that a lat/lng arriving as the
/// string "NaN" survives `asDoubleOrNull` as an actual NaN.
LatLng? safeLatLng(double? lat, double? lng) {
  if (lat == null || lng == null) return null;

  ///every comparison against NaN is false, so it has to be excluded by itself
  ///before the range check can mean anything
  if (!lat.isFinite || !lng.isFinite) return null;
  if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return null;
  return LatLng(lat, lng);
}

/// The tile layer every map in the app draws on top of.
class AppTileLayer extends StatelessWidget {
  const AppTileLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: kOsmTileUrlTemplate,
      userAgentPackageName: kOsmUserAgentPackageName,
      maxNativeZoom: kOsmMaxZoom.toInt(),

      ///the default is the legacy a/b/c subdomains, which osm no longer
      ///serves — leaving them in place produces intermittently broken tiles
      subdomains: const [],
    );
  }
}

/// The credit the OSM tile policy requires to be visible on any map drawn with
/// its tiles: it has to stay on screen rather than hide behind a toggle, and
/// tapping it opens the licence.
class AppMapAttribution extends StatelessWidget {
  const AppMapAttribution({super.key, this.alignment = Alignment.bottomLeft});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => launchUrl(
          Uri.parse('https://www.openstreetmap.org/copyright'),
          mode: LaunchMode.externalApplication,
        ),
        child: Container(
          color: Colors.white70,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: const Text(
            '© OpenStreetMap contributors',
            style: TextStyle(fontSize: 9, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}

/// The pin dropped on a chosen or saved location, shaped like the Google Maps
/// marker it replaces: the tip of the pin sits on the coordinate, so the
/// marker is anchored by its bottom edge.
class AppMapMarker extends Marker {
  const AppMapMarker({required LatLng point})
      : super(
          point: point,
          width: 40,
          height: 40,
          alignment: Alignment.topCenter,
          child: const Icon(
            Icons.location_on,
            color: AppColors.kRed,
            size: 40,
          ),
        );
}

/// Draws the device's own position — the blue dot Google's `myLocationEnabled`
/// drew for free.
///
/// It resolves the position itself rather than taking one from the screen
/// around it: `LocationCubit.currentPosition` is only ever populated by the
/// checkout and registration flows, so a map that relied on it showed no dot at
/// all on the profile and store-location screens.
class MyLocationLayer extends StatefulWidget {
  const MyLocationLayer({super.key, this.requestFix = false});

  /// Ask the OS for a fresh fix when it has no cached position. Worth it where
  /// the dot is the reference the user is picking against; not worth spinning
  /// up GPS to decorate a preview card.
  final bool requestFix;

  @override
  State<MyLocationLayer> createState() => _MyLocationLayerState();
}

class _MyLocationLayerState extends State<MyLocationLayer> {
  LatLng? _point;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  ///best effort throughout: the dot is a convenience, so a refused permission
  ///or a device that has never had a fix means no dot, never an error. Nothing
  ///here prompts — the app already asks for location permission at launch, and
  ///a preview card is no place to start asking again
  Future<void> _resolve() async {
    try {
      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }

      Position? position = await Geolocator.getLastKnownPosition();
      position ??= widget.requestFix
          ? await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            )
          : null;

      final Position? fix = position;
      if (fix == null || !mounted) return;
      setState(() => _point = LatLng(fix.latitude, fix.longitude));
    } catch (_) {
      // the map is perfectly usable without the dot
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? point = _point;
    if (point == null) return const SizedBox.shrink();
    return MarkerLayer(markers: [MyLocationMarker(point: point)]);
  }
}

/// The blue dot the Google map drew for `myLocationEnabled`.
class MyLocationMarker extends Marker {
  const MyLocationMarker({required LatLng point})
      : super(
          point: point,
          width: 22,
          height: 22,
          child: const _MyLocationDot(),
        );
}

class _MyLocationDot extends StatelessWidget {
  const _MyLocationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kBlue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(blurRadius: 4, color: Colors.black26),
        ],
      ),
    );
  }
}
