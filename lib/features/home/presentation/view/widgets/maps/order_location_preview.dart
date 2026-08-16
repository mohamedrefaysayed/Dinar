import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/widgets/maps/app_map.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

/// The read-only map at the top of an order's details, showing where the order
/// is being delivered. Both the customer's and the delivery driver's order
/// screens render this.
class OrderLocationPreview extends StatelessWidget {
  const OrderLocationPreview({super.key, required this.location});

  /// The order's location as the api stores it: a
  /// 'https://www.google.com/maps?q=lat,lng' link. Null on older orders that
  /// were placed before a location was recorded.
  final String? location;

  @override
  Widget build(BuildContext context) {
    final List<double> latLng = location != null
        ? context.read<OrderCubit>().extractLatLng(location!)
        : const [28.8993468, 76.6250249];
    final LatLng target = LatLng(latLng.first, latLng.last);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 250.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.w),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.kGrey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
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
      ),
    );
  }
}
