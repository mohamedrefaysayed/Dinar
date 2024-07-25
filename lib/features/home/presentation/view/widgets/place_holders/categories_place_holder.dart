import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesPlaceHolder extends StatelessWidget {
  const CategoriesPlaceHolder({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: AppColors.primaryColor.withOpacity(0.5),
      child: Padding(
        padding:
            EdgeInsets.only(right: 20.w, left: 20.w, top: 30.h, bottom: 20.h),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Container(
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
            ),
            SizedBox(
              width: 10.w,
            ),
            Flexible(
              flex: 1,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
