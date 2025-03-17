import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PropertyRightsRichText extends StatelessWidget {
  const PropertyRightsRichText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'All Rights Reserved To ',
            style: TextStyles.textStyle16.copyWith(
              color: AppColors.kWhite.withOpacity(0.7),
              fontSize: 16.w,
            ),
          ),
          TextSpan(
            text: 'Mohamed Refay',
            style: TextStyles.textStyle16.copyWith(
              color: Colors.white,
              fontSize: 16.w,
            ),
          ),
        ],
      ),
    );
  }
}
