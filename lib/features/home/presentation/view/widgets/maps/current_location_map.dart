import 'package:dinar_store/core/widgets/maps/app_map.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/map_place_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class CurrentLocationMap extends StatelessWidget {
  const CurrentLocationMap({
    super.key,
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    final LatLng? target = safeLatLng(lat, lng);

    ///a store whose saved coordinates are unusable gets the same placeholder as
    ///one whose profile has not loaded yet, rather than a thrown marker
    if (target == null) return const MapPlaceHolder();

    return Container(
      height: 200.h,
      width: 300.w,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.w),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: target,
            initialZoom: 18,
            maxZoom: kOsmMaxZoom,
            interactionOptions: kPreviewInteractionOptions,
          ),
          children: [
            const AppTileLayer(),
            const MyLocationLayer(),
            MarkerLayer(markers: [AppMapMarker(point: target)]),
            const AppMapAttribution(),
          ],
        ),
      ),
    );
  }
}
