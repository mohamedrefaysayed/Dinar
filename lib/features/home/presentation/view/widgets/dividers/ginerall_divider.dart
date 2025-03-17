import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralDivider extends StatelessWidget {
  const GeneralDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        height: 10.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.25),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 10.w,
              offset: Offset(0, 3.h),
            ),
          ],
          // borderRadius: BorderRadius.circular(15.w),
        ),
      ),
    );
  }
}
