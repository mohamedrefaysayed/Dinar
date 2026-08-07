import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/sub_category_container_home.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/sub_category_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/whole_sub_category_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({super.key, required this.category});

  final Categories category;

  void _openCategory(BuildContext context) {
    Navigator.push(
      context,
      RightSlideTransition(
        page: SubCategoryView(
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///the current backend serves /categories as a flat list of the top level
    ///only: it carries no 'description' and no 'sub_categories' at all, so
    ///both of these used to throw "Null check operator used on a null value"
    ///once per category and took the whole home screen down
    final String description = category.description?.trim() ?? '';
    final List<SubCategories> subCategories =
        category.subCategories ?? const <SubCategories>[];

    return Material(
      color: AppColors.kWhite,
      child: InkWell(
        onTap: () => _openCategory(context),
        child: Container(
          color: AppColors.kWhite,
          child: Column(
            children: [
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _openCategory(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 10.w,
                      color: Colors.grey,
                    ),
                    label: Text(
                      'عرض المزيد',
                      style: TextStyles.textStyle10.copyWith(
                          fontWeight: FontWeight.w400, color: Colors.grey),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          category.categoryName ?? '',
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.w,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      if (subCategories.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999.w),
                          ),
                          child: Text(
                            '${subCategories.length}',
                            style: TextStyles.textStyle10.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              if (description.isNotEmpty)
                SizedBox(
                  width: 300.w,
                  child: Text(
                    description,
                    style: TextStyles.textStyle12.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              SizedBox(
                height: 10.h,
              ),

              ///collapse the strip entirely rather than stacking a "no items" box
              ///under every category, which is what this backend would produce
              if (subCategories.isNotEmpty)
                SizedBox(
                  height: 180.h,
                  child: ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      return SubCategoryContainerHome(
                        subCategory: subCategories[index],
                        onPress: () {
                          Navigator.push(
                            context,
                            RightSlideTransition(
                              page: WholeSubCategoryView(
                                subCategory: subCategories[index],
                                subCategories: subCategories,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              const GeneralDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
