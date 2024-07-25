import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/functions/future_delayed_navigator.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/sub_sub_categories_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCategoryContainer extends StatelessWidget {
  const SubCategoryContainer({
    super.key,
    required this.subCategory,
  });

  final SubCategories subCategory;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 250.w,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.w),
            color: AppColors.kWhite,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.w),
                child: MyCachedNetworkImage(
                  height: 120.h,
                  width: 240.w,
                  url: subCategory.image!,
                  errorIcon: Icon(
                    Icons.image,
                    size: 100.w,
                    color: AppColors.primaryColor,
                  ),
                  loadingWidth: 30.w,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 200.w,
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
                width: 200.w,
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
                Navigator.push(
                    context,
                    RightSlideTransition(
                        page: SubSubCategoryView(subcategory: subCategory)));
              });
            },
            borderRadius: BorderRadius.circular(15.w),
            child: SizedBox(height: 120.w, width: 250.w),
          ),
        ),
      ],
    );
  }
}
