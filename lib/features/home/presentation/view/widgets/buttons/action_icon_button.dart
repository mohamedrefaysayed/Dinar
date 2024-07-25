import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionIconButton extends StatelessWidget {
  const ActionIconButton({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Stack(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 30.w,
              width: 30.w,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Icon(
                icon,
                size: 20.w,
                color: AppColors.kWhite,
              )),
            ),
          ),
          Container(
            height: 30.w,
            width: 30.w,
            decoration: const BoxDecoration(
                color: AppColors.kTransparent, shape: BoxShape.circle),
            child: const Material(
              color: AppColors.kTransparent,
            ),
          ),
        ],
      ),
    );
  }
}
