// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/listviews/whole_sub_category_list_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/search_rows/search_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_category_products_cubit/sub_category_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WholeSubCategoryView extends StatefulWidget {
  const WholeSubCategoryView({
    super.key,
    required this.subCategory,
    required this.subCategories,
  });

  final SubCategories subCategory;
  final List<SubCategories> subCategories;

  @override
  State<WholeSubCategoryView> createState() => _WholeSubCategoryViewState();
}

class _WholeSubCategoryViewState extends State<WholeSubCategoryView>
    with SingleTickerProviderStateMixin {
  ValueNotifier<double> imageHight = ValueNotifier(250.h);
  ValueNotifier<bool> searching = ValueNotifier(false);

  ValueNotifier<ScrollController> scrollController = ValueNotifier(
    ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true),
  );
  int initialIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    for (int index = 0; index < widget.subCategories.length; index++) {
      if (widget.subCategories[index] == widget.subCategory) {
        initialIndex = index;
      }
    }
    tabController = TabController(
      initialIndex: initialIndex,
      length: widget.subCategories.length,
      vsync: this,
    );
    context
        .read<SubCategoryProductCubit>()
        .getSubCategoryWithProduct(catId: widget.subCategory.id!);

    scrollController.value.addListener(() {
      if (SubCategoryProductCubit.subCategoryProductsModel.products!.length >
          5) {
        if (scrollController.value.offset > 100) {
          imageHight.value = 0;
        }
        if (scrollController.value.offset == 0) {
          imageHight.value = 250.h;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: imageHight,
      builder: (BuildContext context, double imgHeightValue, Widget? child) {
        return PopScope(
          canPop: imgHeightValue == 0 ? false : true,
          onPopInvoked: (didPop) {
            if (imgHeightValue == 0) {
              tabController.index = initialIndex;
              SubCategoryProductCubit.subCategoriesController.clear();
              imageHight.value = 250.h;
              context
                  .read<SubCategoryProductCubit>()
                  .getSubCategoryWithProduct(catId: widget.subCategory.id!);
            }
          },
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                context
                    .read<SubCategoryProductCubit>()
                    .getSubCategoryWithProduct(catId: widget.subCategory.id!);
              },
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    AnimatedContainer(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.w)),
                      height: imgHeightValue,
                      duration: const Duration(milliseconds: 800),
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'SubCat${widget.subCategory.id}',
                            child: MyCachedNetworkImage(
                              url: widget.subCategory.image!,
                              height: imgHeightValue,
                              width: double.infinity,
                              errorIcon: Icon(
                                Icons.image,
                                size: 150.w,
                                color: AppColors.kASDCPrimaryColor,
                              ),
                              loadingWidth: 13.w,
                            ),
                          ),
                          if (imgHeightValue != 0)
                            Positioned(
                              left: 20.w,
                              bottom: 10.h,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.kWhite.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite,
                                        color: AppColors.kRed,
                                        size: 25.w,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.kWhite.withOpacity(0.7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        if (!searching.value) {
                                          searching.value = true;
                                        } else {
                                          searching.value = false;
                                          SubCategoryProductCubit
                                              .subCategoriesController
                                              .clear();
                                          context
                                              .read<SubCategoryProductCubit>()
                                              .searchInProducts();
                                        }
                                      },
                                      icon: ValueListenableBuilder(
                                        valueListenable: searching,
                                        builder: (BuildContext context,
                                                bool value, Widget? child) =>
                                            Icon(
                                          value ? Icons.close : Icons.search,
                                          color: AppColors.kASDCPrimaryColor,
                                          size: 25.w,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ValueListenableBuilder(
                            valueListenable: searching,
                            builder: (BuildContext context, bool value,
                                    Widget? child) =>
                                value
                                    ? Positioned(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 50.h,
                                            ),
                                            SizedBox(
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 20.w),
                                                decoration: BoxDecoration(
                                                  color: AppColors.kWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.w),
                                                ),
                                                child: SearchRow(
                                                    autofocus: true,
                                                    onDismiss: () {
                                                      // searching.value = false;
                                                      // SubCategoryProductCubit
                                                      //     .subCategoriesController
                                                      //     .clear();
                                                      // context
                                                      //     .read<
                                                      //         SubCategoryProductCubit>()
                                                      //     .searchInProducts();
                                                    },
                                                    textEditingController:
                                                        SubCategoryProductCubit
                                                            .subCategoriesController,
                                                    hintText: 'ابحث عن المنتج',
                                                    canGoBack: false,
                                                    haveFilter: false,
                                                    onChanged: (_) {
                                                      context
                                                          .read<
                                                              SubCategoryProductCubit>()
                                                          .searchInProducts();
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 15.h),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(seconds: 2),
                              height: imgHeightValue == 0 ? null : 0,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 50.h,
                                          child: TabBar(
                                              controller: tabController,
                                              onTap: (index) {
                                                context
                                                    .read<
                                                        SubCategoryProductCubit>()
                                                    .getSubCategoryWithProduct(
                                                        catId: widget
                                                            .subCategories[
                                                                index]
                                                            .id!);
                                              },
                                              tabs: List.generate(
                                                  widget.subCategories.length,
                                                  (index) => Tab(
                                                        height: 60.h,
                                                        child: Text(
                                                          widget
                                                              .subCategories[
                                                                  index]
                                                              .categoryName!,
                                                          style: TextStyles
                                                              .textStyle14,
                                                        ),
                                                      ))),
                                        ),
                                      ),
                                      Transform.flip(
                                        flipX: true,
                                        child: IconButton(
                                            onPressed: () {
                                              tabController.index =
                                                  initialIndex;
                                              SubCategoryProductCubit
                                                  .subCategoriesController
                                                  .clear();
                                              imageHight.value = 250.h;
                                              context
                                                  .read<
                                                      SubCategoryProductCubit>()
                                                  .getSubCategoryWithProduct(
                                                      catId: widget
                                                          .subCategory.id!);
                                            },
                                            icon: Icon(
                                              Icons.arrow_back,
                                              color:
                                                  AppColors.kASDCPrimaryColor,
                                              size: 25.w,
                                            )),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(seconds: 2),
                              height: imgHeightValue != 0 ? null : 0,
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.subCategory.categoryName!,
                                      style: TextStyles.textStyle16.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.w,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    Text(
                                      widget.subCategory.description!,
                                      style: TextStyles.textStyle10.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const GeneralDivider(),
                            Expanded(
                              child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: tabController,
                                  children: List.generate(
                                    widget.subCategories.length,
                                    (index) => WholeSubCategoryListView(
                                      scrollController: scrollController,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
