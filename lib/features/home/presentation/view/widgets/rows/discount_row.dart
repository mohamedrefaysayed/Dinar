import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountRow extends StatelessWidget {
  const DiscountRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30.w,
        vertical: 10.h,
      ),
      child: DottedBorder(
        dashPattern: const [6, 6],
        borderType: BorderType.RRect,
        radius: Radius.circular(15.w),
        color: AppColors.kASDCPrimaryColor,
        strokeWidth: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: SizedBox(
            height: 45.h,
            child: Row(
              children: [
                AppDefaultButton(
                  onPressed: () {},
                  title: "تطبيق",
                  width: 70.w,
                  color: AppColors.kASDCPrimaryColor,
                  textStyle: TextStyles.textStyle12.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.kWhite,
                  ),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ادخل كود الخصم',
                      hintStyle: TextStyles.textStyle14,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  height: 30.w,
                  width: 30.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.kASDCPrimaryColor,
                        width: 1.w,
                      )),
                  child: Center(
                    child: Text(
                      "%",
                      style: TextStyles.textStyle16.copyWith(
                        color: AppColors.kASDCPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
