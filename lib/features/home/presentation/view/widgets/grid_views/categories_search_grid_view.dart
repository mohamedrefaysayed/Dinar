// ignore_for_file: use_build_context_synchronously

import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/data/models/search_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/search_item_row.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/sub_category_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/sub_sub_categories_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/whole_sub_category_view.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_categories_cubit/sub_categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesSearchGridView extends StatelessWidget {
  const CategoriesSearchGridView({super.key, required this.categories});

  final List<SearchCategory> categories;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GeneralDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "المجموعــــــات",
              style: TextStyles.textStyle16.copyWith(
                fontSize: 16.w,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const GeneralDivider(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) => SearchItem(
            imag: categories[index].image!,
            name: categories[index].categoryName!,
            onTap: () async {
              Map<String, dynamic> data = categories[index].toJson();
              if (categories[index].level == "1") {
                Navigator.push(
                    context,
                    RightSlideTransition(
                        page: SubCategoryView(
                      category: Categories.fromJson(data),
                      getData: true,
                    )));
              }
              if (categories[index].level == "2") {
                Navigator.push(
                    context,
                    RightSlideTransition(
                        page: SubSubCategoryView(
                      subcategory: SubCategories.fromJson(data),
                    )));
              }
              if (categories[index].level == "3") {
                await context.read<SubCategoriesCubit>().getAllSubSubCategories(
                      catId: int.parse(
                        categories[index].parentId!,
                      ),
                    );
                Navigator.push(
                    context,
                    RightSlideTransition(
                        page: WholeSubCategoryView(
                      subCategories: SubCategoriesCubit.subCategories,
                      subCategory: SubCategoriesCubit.subCategories.firstWhere(
                          (element) => element.id == categories[index].id),
                    )));
              }
            },
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            childAspectRatio: 115.h / 135.w,
          ),
        ),
      ],
    );
  }
}
