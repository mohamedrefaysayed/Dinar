import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/sub_category_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesPgeView extends StatelessWidget {
  const CategoriesPgeView({
    super.key,
    required this.pageController,
    required this.categoriesModel,
  });

  final PageController pageController;
  final CategoriesModel categoriesModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: List.generate(categoriesModel.categories!.length, (index) {
          Categories category = categoriesModel.categories![index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    category.categoryName!,
                    style: TextStyles.textStyle16.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.w,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              category.subCategories!.isEmpty
                  ? SizedBox(
                      height: 150.h,
                      child: Center(
                        child: Text(
                          'لا يوجد عناصر',
                          style: TextStyles.textStyle14,
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: category.subCategories!.length,
                          itemBuilder: (context, index) {
                            return SubCategoryContainer(
                              subCategory: category.subCategories![index],
                              subCategories: category.subCategories!,
                            );
                          },
                        ),
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}
