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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.kWhite,
      child: Column(
        children: [
          Row(
            children: [
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      RightSlideTransition(
                        page: SubCategoryView(
                          category: category,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 10.w,
                    color: Colors.grey,
                  ),
                  label: Text(
                    'عرض المزيد',
                    style: TextStyles.textStyle10.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                  )),
              const Spacer(),
              SizedBox(
                width: 200.w,
                child: Text(
                  category.categoryName!,
                  style: TextStyles.textStyle16.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.w,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 300.w,
            child: Text(
              category.description!,
              style: TextStyles.textStyle12
                  .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 180.h,
            child: category.subCategories!.isEmpty
                ? SizedBox(
                    height: 150.h,
                    child: Center(
                      child: Text(
                        'لا يوجد عناصر',
                        style:
                            TextStyles.textStyle14.copyWith(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: category.subCategories!.length,
                    itemBuilder: (context, index) {
                      return SubCategoryContainerHome(
                        subCategory: category.subCategories![index],
                        onPress: () {
                          Navigator.push(
                            context,
                            RightSlideTransition(
                              page: WholeSubCategoryView(
                                subCategory: category.subCategories![index],
                                subCategories: category.subCategories!,
                              ),
                            ),
                          );
                          // Navigator.push(
                          //   context,
                          //   RightSlideTransition(
                          //     page: SubSubCategoryView(
                          //       subcategory: category.subCategories![index],
                          //     ),
                          //   ),
                          // );
                        },
                      );
                    },
                  ),
          ),
          const GeneralDivider(),
        ],
      ),
    );
  }
}
