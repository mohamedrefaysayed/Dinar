// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view_model/categories_cubit/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesVerticalTabBar extends StatelessWidget {
  const CategoriesVerticalTabBar({
    super.key,
    required this.categoriesModel,
  });

  final CategoriesModel categoriesModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: ListView.separated(
        itemCount: categoriesModel.categories!.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 5.h);
        },
        itemBuilder: (context, index) {
          Categories category = categoriesModel.categories![index];
          return GestureDetector(
            onTap: () {
              context.read<CategoriesCubit>().changeCategory(
                  index: index, categoriesModel: categoriesModel);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: CategoriesCubit.selectedIndex == index ? 90.h : 0,
                  width: 2.w,
                  color: AppColors.primaryColor,
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  color: CategoriesCubit.selectedIndex == index
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : AppColors.kTransparent,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.w),
                          child: MyCachedNetworkImage(
                            height: 35.w,
                            width: 35.w,
                            url: category.image!,
                            errorIcon: Icon(
                              Icons.home_work_rounded,
                              size: 30.w,
                              color: AppColors.primaryColor,
                            ),
                            loadingWidth: 13.w,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          category.categoryName!,
                          style: TextStyles.textStyle12
                              .copyWith(fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
