import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AllCompaniesPlaceHolder extends StatelessWidget {
  const AllCompaniesPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: AppColors.primaryColor.withOpacity(0.5),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 7.5.h),
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.161),
                  blurRadius: 6.w,
                  offset: Offset(0, 3.h),
                ),
              ],
              borderRadius: BorderRadius.circular(15.w),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1.w,
              ),
            ),
          );
        },
      ),
    );
  }
}
