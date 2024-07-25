import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesPlaceHolderHome extends StatelessWidget {
  const CategoriesPlaceHolderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: AppColors.primaryColor.withOpacity(0.5),
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.w),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.161),
                  blurRadius: 6.w,
                  offset: Offset(0, 3.h)),
            ]),
      ),
    );
  }
}
