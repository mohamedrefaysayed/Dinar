import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

extension SnackbarContext on BuildContext {
  void showMessageSnackBar({
    required String message,
    Color? color,
    String? imagePath,
    bool? isBottomNavBar,
  }) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40.h,
        left: 20.w,
        right: 20.w,
        child: Material(
          elevation: 20,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.w),
            side: BorderSide(color: Colors.black, width: 1.sp),
          ),
          child: Container(
            margin: EdgeInsets.only(right: 24.w, left: 24.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imagePath != null)
                  SvgPicture.asset(
                    imagePath,
                    height: 24.h,
                    width: 29.w,
                    colorFilter:
                        const ColorFilter.mode(Colors.blue, BlendMode.srcATop),
                  ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyles.textStyle14,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  height: 10.w,
                  width: 10.w,
                  decoration: BoxDecoration(
                    color: color ?? Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(this).insert(overlayEntry);

    Future.delayed(
        Duration(
          seconds: message.length > 50
              //5 seconds for long errMessage
              ? 5
              : message.length < 20
                  //3 seconds for short errMessage
                  ? 3
                  //4 seconds for medium errMessage
                  : 4,
        ), () {
      overlayEntry.remove();
    });
  }
}
