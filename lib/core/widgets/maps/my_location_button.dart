import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/widgets/maps/app_map.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

/// The round "centre on me" button the Google map drew for
/// `myLocationButtonEnabled`.
///
/// Tapping it gets a fresh fix, pans the map to it at the current zoom, and
/// hands the fix to [onLocated] so the screen can move its blue dot along.
/// Sits over the map in a [Stack]; pick where with [alignment].
class MyLocationButton extends StatefulWidget {
  const MyLocationButton({
    super.key,
    required this.mapController,
    this.onLocated,
    this.alignment = Alignment.bottomRight,
  });

  final MapController mapController;

  /// called with the fix after the map has moved to it
  final ValueChanged<LatLng>? onLocated;

  final Alignment alignment;

  @override
  State<MyLocationButton> createState() => _MyLocationButtonState();
}

class _MyLocationButtonState extends State<MyLocationButton> {
  bool _locating = false;

  Future<void> _locate() async {
    if (_locating) return;
    setState(() => _locating = true);

    ///the user just asked for their position, so this is the one place a
    ///permission prompt is welcome — and a stale cached position is not what
    ///they asked for, hence the fresh fix
    final LatLng? point = await resolveMyLocation(
      requestPermission: true,
      requestFix: true,
    );
    if (!mounted) return;
    setState(() => _locating = false);

    if (point == null) {
      context.showMessageSnackBar(
        message: 'تعذر تحديد موقعك، تأكد من تفعيل خدمة الموقع والسماح للتطبيق باستخدامها',
      );
      return;
    }

    widget.mapController.move(point, widget.mapController.camera.zoom);
    widget.onLocated?.call(point);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Material(
          color: AppColors.kWhite,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _locate,
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Center(
                child: _locating
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      )
                    : Icon(
                        Icons.my_location,
                        color: AppColors.primaryColor,
                        size: 24.w,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
