import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.imag,
    required this.name,
    required this.onTap,
  });

  final String imag;
  final String name;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.w),
                child: MyCachedNetworkImage(
                    fit: BoxFit.contain,
                    height: 100.w,
                    width: 150.w,
                    url: imag,
                    errorIcon: const Icon(
                      Icons.image,
                      color: AppColors.kASDCPrimaryColor,
                    ),
                    loadingWidth: 13.w),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Text(
                      name,
                      style: TextStyles.textStyle14,
                      textDirection: TextDirection.rtl,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
    );
  }
}
