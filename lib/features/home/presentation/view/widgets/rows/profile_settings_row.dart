import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSettingsRow extends StatelessWidget {
  const ProfileSettingsRow({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    this.wDevider,
    this.iconColor,
  });

  final String title;
  final void Function() onTap;
  final IconData icon;
  final bool? wDevider;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                children: [
                  if (wDevider != null && wDevider!)
                    Icon(
                      Icons.arrow_back_ios,
                      size: 20.w,
                      color: AppColors.kASDCPrimaryColor,
                    ),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyles.textStyle16.copyWith(
                      fontSize: 16.w,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(
                    icon,
                    size: 20.w,
                    color: iconColor ?? AppColors.kASDCPrimaryColor,
                  ),
                ],
              ),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.w),
                  child: Material(
                    color: AppColors.kTransparent,
                    child: InkWell(
                      onTap: onTap,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (wDevider != null && wDevider!) const GeneralDivider(),
        ],
      ),
    );
  }
}
