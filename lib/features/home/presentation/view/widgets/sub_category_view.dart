// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/sub_category_container_home.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/categories_place_holder_home.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/search_rows/search_row.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/whole_sub_category_view.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_categories_cubit/sub_categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCategoryView extends StatefulWidget {
  const SubCategoryView({
    super.key,
    required this.category,
    this.getData,
  });

  final Categories category;
  final bool? getData;

  @override
  State<SubCategoryView> createState() => _SubCategoryViewState();
}

class _SubCategoryViewState extends State<SubCategoryView> {
  @override
  void initState() {
    if (widget.getData != null && widget.getData!) {
      context
          .read<SubCategoriesCubit>()
          .getAllSubSubCategories(catId: widget.category.id!);
    } else {
      SubCategoriesCubit.subCategories = widget.category.subCategories!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        SubCategoriesCubit.subCategoriesController.clear();
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<SubCategoriesCubit>()
                .getAllSubSubCategories(catId: widget.category.id!);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 50.h, right: 20.w, left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SearchRow(
                  textEditingController:
                      SubCategoriesCubit.subCategoriesController,
                  hintText: 'ابحث عن مجموعة',
                  canGoBack: true,
                  whenBack: () {
                    Navigator.pop(context);
                  },
                  haveFilter: true,
                  onFilter: () {},
                  onChanged: (val) {
                    context.read<SubCategoriesCubit>().searchInSubCategory();
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  widget.category.categoryName!,
                  style: TextStyles.textStyle18
                      .copyWith(fontWeight: FontWeight.w700),
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  widget.category.description!,
                  style: TextStyles.textStyle12.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.grey),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      BlocConsumer<SubCategoriesCubit, SubCategoriesState>(
                        listener: (context, state) {
                          if (state is SubCategoriesSuccess) {
                            SubCategoriesCubit.subCategories = state.categories;
                          }
                        },
                        builder: (context, state) {
                          if (state is SubCategoriesSuccess ||
                              state is SubCategoriesInitial) {
                            return SubCategoriesCubit
                                    .subCategoriesController.text.isEmpty
                                ? SubCategoriesCubit.subCategories.isEmpty
                                    ? ListView(
                                        shrinkWrap: true,
                                        children: [
                                          SizedBox(
                                            height: 150.h,
                                            child: Center(
                                              child: Text(
                                                'لا يوجد عناصر',
                                                style: TextStyles.textStyle14
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: SubCategoriesCubit
                                            .subCategories.length,
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              SubCategoryContainerHome(
                                                subCategory: SubCategoriesCubit
                                                    .subCategories[index],
                                                onPress: () {
                                                  Navigator.push(
                                                    context,
                                                    RightSlideTransition(
                                                      page:
                                                          WholeSubCategoryView(
                                                        subCategory:
                                                            SubCategoriesCubit
                                                                    .subCategories[
                                                                index],
                                                        subCategories:
                                                            SubCategoriesCubit
                                                                .subCategories,
                                                      ),
                                                    ),
                                                  );
                                                  // Navigator.push(
                                                  //   context,
                                                  //   RightSlideTransition(
                                                  //     page: SubSubCategoryView(
                                                  //       subcategory:
                                                  //           SubCategoriesCubit
                                                  //                   .subCategories[
                                                  //               index],
                                                  //     ),
                                                  //   ),
                                                  // );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                        addAutomaticKeepAlives: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 15.w,
                                          childAspectRatio: 115.h / 135.w,
                                        ),
                                      )
                                : SubCategoriesCubit.subCategoriesSearch.isEmpty
                                    ? ListView(
                                        shrinkWrap: true,
                                        children: [
                                          SizedBox(
                                            height: 150.h,
                                            child: Center(
                                              child: Text(
                                                'لا يوجد',
                                                style: TextStyles.textStyle14
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : GridView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: SubCategoriesCubit
                                            .subCategoriesSearch.length,
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              SubCategoryContainerHome(
                                                subCategory: SubCategoriesCubit
                                                    .subCategoriesSearch[index],
                                                onPress: () {
                                                  Navigator.push(
                                                    context,
                                                    RightSlideTransition(
                                                      page:
                                                          WholeSubCategoryView(
                                                        subCategory:
                                                            SubCategoriesCubit
                                                                    .subCategoriesSearch[
                                                                index],
                                                        subCategories:
                                                            SubCategoriesCubit
                                                                .subCategoriesSearch,
                                                      ),
                                                    ),
                                                  );
                                                  // futureDelayedNavigator(() {
                                                  //   Navigator.push(
                                                  //       context,
                                                  //       RightSlideTransition(
                                                  //           page:
                                                  //               SubSubCategoryView(
                                                  //         subcategory:
                                                  //             SubCategoriesCubit
                                                  //                     .subCategories[
                                                  //                 index],
                                                  //       )));
                                                  // });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                        addAutomaticKeepAlives: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 15.w,
                                                childAspectRatio:
                                                    115.h / 155.w),
                                      );
                          }
                          return Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return const CategoriesPlaceHolderHome();
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 10.h,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
