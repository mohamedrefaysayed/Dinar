import 'package:dinar_store/core/functions/future_delayed_navigator.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCategoryContainerHome extends StatelessWidget {
  const SubCategoryContainerHome({
    super.key,
    required this.subCategory,
    required this.onPress,
  });

  final SubCategories subCategory;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            width: 170.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.w),
              color: AppColors.kWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Hero(
                  tag: "SubCat${subCategory.id}",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.w),
                    child: MyCachedNetworkImage(
                      height: 120.h,
                      width: 160.w,
                      url: subCategory.image!,
                      errorIcon: Icon(
                        Icons.image,
                        size: 100.w,
                        color: AppColors.primaryColor,
                      ),
                      loadingWidth: 30.w,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    subCategory.categoryName!,
                    style: TextStyles.textStyle14.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(
                  width: 120.w,
                  child: Text(
                    subCategory.description!,
                    style: TextStyles.textStyle10.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.kTransparent,
            child: InkWell(
              onTap: () {
                futureDelayedNavigator(() {
                  onPress();
                });
              },
              borderRadius: BorderRadius.circular(15.w),
              child: SizedBox(
                width: 170.w,
                height: 120.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
