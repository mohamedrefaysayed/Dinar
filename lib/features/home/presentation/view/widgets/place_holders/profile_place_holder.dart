import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePLaceHolder extends StatelessWidget {
  const ProfilePLaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: AppColors.primaryColor.withOpacity(0.5),
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                height: 30.h,
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  borderRadius: BorderRadius.circular(15.w),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 20.h,
              );
            },
            itemCount: 6,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 35.w),
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(15.w),
            ),
          ),
          Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(15.w),
            ),
          ),
        ],
      ),
    );
  }
}
