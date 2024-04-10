import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderConfirmActionRow extends StatelessWidget {
  const OrderConfirmActionRow({
    super.key,
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    required this.buttonWidth,
    required this.icon,
  });

  final void Function() onTap;
  final String title;
  final String subTitle;
  final String buttonTitle;
  final double buttonWidth;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppDefaultButton(
          onPressed: onTap,
          title: buttonTitle,
          width: buttonWidth,
          color: AppColors.kWhite,
          textStyle: TextStyles.textStyle12.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.kASDCPrimaryColor,
          ),
          icon: Icon(
            icon,
            size: 25.w,
            color: AppColors.kASDCPrimaryColor,
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: 200.w,
              child: Text(
                title,
                style: TextStyles.textStyle16.copyWith(
                  fontSize: 16.w,
                ),
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              width: 200,
              child: Text(
                subTitle,
                style: TextStyles.textStyle14.copyWith(
                    color: AppColors.kASDCPrimaryColor,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
