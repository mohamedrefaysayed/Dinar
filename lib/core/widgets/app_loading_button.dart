import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoadingButton extends StatelessWidget {
  const AppLoadingButton({
    super.key,
    this.showBorder = false,
    this.margin,
    this.height,
    this.width,
  });

  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50.h,
      width: width ?? 300.w,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
        border: showBorder
            ? Border.all(color: AppColors.primaryColor, width: 1.w)
            : null,
        color: Colors.white,
      ),
      child: SpinKitThreeBounce(
        color: AppColors.primaryColor,
        size: 24.w,
      ),
    );
  }
}
