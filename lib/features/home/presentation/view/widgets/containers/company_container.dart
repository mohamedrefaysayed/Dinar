import 'dart:math';

import 'package:dinar_store/core/functions/future_delayed_navigator.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/app_icons.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CompanyContainer extends StatelessWidget {
  const CompanyContainer({
    super.key,
    required this.companyName,
    this.compantIconImage,
    required this.onTap,
    this.isMore,
    required this.index,
    required this.heroId,
  });

  final String companyName;
  final String? compantIconImage;
  final void Function() onTap;
  final bool? isMore;
  final int index;
  final int heroId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 75.w,
          width: 75.w,
          decoration: BoxDecoration(
            color: (isMore != null && isMore!)
                ? const Color(0xffE7F2EC)
                : comapniesBgColor[Random().nextInt(4)],
            borderRadius: BorderRadius.circular(15.w),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.161),
                  blurRadius: 6.w,
                  offset: Offset(0, 3.h)),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (isMore != null && isMore!)
                    ? SvgPicture.asset(
                        height: 25.w,
                        width: 25.w,
                        AppIcons.more,
                      )
                    : Hero(
                        tag: "Company$heroId",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.w),
                          child: MyCachedNetworkImage(
                            height: 35.w,
                            width: 35.w,
                            url: compantIconImage!,
                            errorIcon: Icon(
                              Icons.home_work_rounded,
                              size: 30.w,
                              color: AppColors.primaryColor,
                            ),
                            loadingWidth: 13.w,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  companyName,
                  style: TextStyles.textStyle10
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        Material(
          color: AppColors.kTransparent,
          child: InkWell(
            onTap: () {
              futureDelayedNavigator(() {
                onTap();
              });
            },
            borderRadius: BorderRadius.circular(15.w),
            child: SizedBox(
              height: 75.w,
              width: 75.w,
            ),
          ),
        ),
      ],
    );
  }
}
