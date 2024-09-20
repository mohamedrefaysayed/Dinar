// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'package:dinar_store/core/animations/left_slide_transition.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/genrall.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/defult_scaffold.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/cart_view.dart';
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

  ValueNotifier<SubCategories> currentSubCategory =
      ValueNotifier(SubCategories());

  List<SubCategories> taBarSubCategories = [];

  @override
  void initState() {
    super.initState();

    taBarSubCategories = widget.subCategories;
    currentSubCategory.value = widget.subCategory;
    for (int index = 0; index < taBarSubCategories.length; index++) {
      if (taBarSubCategories[index].id == widget.subCategory.id) {
        initialIndex = index;
      }
    }
    tabController = TabController(
      initialIndex: initialIndex,
      length: taBarSubCategories.length,
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
          child: DefultScaffold(
            canPop: true,
            body: SafeArea(
              child: DefaultTabController(
                length: taBarSubCategories.length,
                initialIndex: initialIndex,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TabBar(
                          dividerColor: AppColors.kWhite,
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
                          isScrollable: true,
                          onTap: (index) {
                            context
                                .read<SubCategoryProductCubit>()
                                .getSubCategoryWithProduct(
                                    catId: taBarSubCategories[index].id!);
                            currentSubCategory.value =
                                taBarSubCategories[index];
                            SubCategoryProductCubit.subCategoriesController
                                .clear();
                          },
                          tabs: List.generate(
                            taBarSubCategories.length,
                            (index) => Tab(
                              height: 25.h,
                              child: ValueListenableBuilder(
                                valueListenable: currentSubCategory,
                                builder: (BuildContext context, value,
                                        Widget? child) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    color: taBarSubCategories.indexOf(value) ==
                                            index
                                        ? AppColors.primaryColor
                                        : AppColors.kWhite,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 7.w),
                                      child: Text(
                                        taBarSubCategories[index].categoryName!,
                                        style: TextStyles.textStyle14.copyWith(
                                          color: taBarSubCategories
                                                      .indexOf(value) ==
                                                  index
                                              ? AppColors.kWhite
                                              : AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<SubCategoryProductCubit>()
                              .getSubCategoryWithProduct(
                                  catId: widget.subCategory.id!);
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: currentSubCategory,
                                builder: (BuildContext context,
                                        SubCategories value, Widget? child) =>
                                    AnimatedContainer(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.w),
                                  ),
                                  height: imgHeightValue,
                                  duration: const Duration(milliseconds: 800),
                                  child: Stack(
                                    children: [
                                      Hero(
                                        tag: 'SubCat${value.id}',
                                        child: MyCachedNetworkImage(
                                          fit: BoxFit.fill,
                                          url: value.image!,
                                          height: imgHeightValue,
                                          width: double.infinity,
                                          errorIcon: Icon(
                                            Icons.image,
                                            size: 150.w,
                                            color: AppColors.primaryColor,
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
                                                  color: AppColors.kWhite
                                                      .withOpacity(0.7),
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
                                                  color: AppColors.kWhite
                                                      .withOpacity(0.7),
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
                                                          .read<
                                                              SubCategoryProductCubit>()
                                                          .searchInProducts();
                                                    }
                                                  },
                                                  icon: ValueListenableBuilder(
                                                    valueListenable: searching,
                                                    builder: (BuildContext
                                                                context,
                                                            bool value,
                                                            Widget? child) =>
                                                        Icon(
                                                      value
                                                          ? Icons.close
                                                          : Icons.search,
                                                      color: AppColors
                                                          .primaryColor,
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
                                        builder: (BuildContext context,
                                                bool value, Widget? child) =>
                                            value
                                                ? Positioned(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 50.h,
                                                        ),
                                                        SizedBox(
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        20.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .kWhite,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
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
                                                                hintText:
                                                                    'ابحث عن المنتج',
                                                                canGoBack:
                                                                    false,
                                                                haveFilter:
                                                                    false,
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
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.w, vertical: 15.h),
                                  child: Column(
                                    children: [
                                      // AnimatedContainer(
                                      //   duration: const Duration(seconds: 2),
                                      //   height: imgHeightValue == 0 ? null : 0,
                                      //   child: Column(
                                      //     children: [
                                      //       SizedBox(
                                      //         height: 10.h,
                                      //       ),
                                      //       Row(
                                      //         children: [
                                      //           Expanded(
                                      //             child: SizedBox(
                                      //               height: 50.h,
                                      //               child: TabBar(
                                      //                 controller: tabController,
                                      //                 onTap: (index) {
                                      //                   context
                                      //                       .read<
                                      //                           SubCategoryProductCubit>()
                                      //                       .getSubCategoryWithProduct(
                                      //                           catId: widget
                                      //                               .subCategories[
                                      //                                   index]
                                      //                               .id!);
                                      //                 },
                                      //                 tabs: List.generate(
                                      //                   widget.subCategories
                                      //                       .length,
                                      //                   (index) => Tab(
                                      //                     height: 60.h,
                                      //                     child: Text(
                                      //                       widget
                                      //                           .subCategories[
                                      //                               index]
                                      //                           .categoryName!,
                                      //                       style: TextStyles
                                      //                           .textStyle14,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //           Transform.flip(
                                      //             flipX: true,
                                      //             child: IconButton(
                                      //               onPressed: () {
                                      //                 tabController.index =
                                      //                     initialIndex;
                                      //                 SubCategoryProductCubit
                                      //                     .subCategoriesController
                                      //                     .clear();
                                      //                 imageHight.value = 250.h;
                                      //                 context
                                      //                     .read<
                                      //                         SubCategoryProductCubit>()
                                      //                     .getSubCategoryWithProduct(
                                      //                         catId: widget
                                      //                             .subCategory
                                      //                             .id!);
                                      //               },
                                      //               icon: Icon(
                                      //                 Icons.arrow_back,
                                      //                 color: AppColors
                                      //                     .primaryColor,
                                      //                 size: 25.w,
                                      //               ),
                                      //             ),
                                      //           )
                                      //         ],
                                      //       ),
                                      //       SizedBox(
                                      //         height: 10.h,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      ValueListenableBuilder(
                                        valueListenable: currentSubCategory,
                                        builder: (BuildContext context,
                                                SubCategories value,
                                                Widget? child) =>
                                            AnimatedContainer(
                                          duration: const Duration(seconds: 2),
                                          height:
                                              imgHeightValue != 0 ? null : 0,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  value.categoryName!,
                                                  style: TextStyles.textStyle16
                                                      .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.w,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                ),
                                                Text(
                                                  value.description!,
                                                  style: TextStyles.textStyle10
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey),
                                                  textDirection:
                                                      TextDirection.rtl,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const GeneralDivider(),
                                      Expanded(
                                        child: TabBarView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          controller: tabController,
                                          children: List.generate(
                                            widget.subCategories.length,
                                            (index) => WholeSubCategoryListView(
                                              scrollController:
                                                  scrollController,
                                              subCategory:
                                                  widget.subCategories[index],
                                            ),
                                          ),
                                        ),
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
                  ],
                ),
              ),
            ),
            floatingActionButton: ValueListenableBuilder(
              valueListenable: cartNotEmpty,
              builder: (BuildContext context, bool value, Widget? child) =>
                  value
                      ? Stack(
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  LeftSlideTransition(
                                    page: const CartView(
                                      canPop: true,
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: AppColors.kWhite,
                                size: 30.sp,
                              ),
                            ),
                            Container(
                              height: 10.w,
                              width: 10.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.kRed,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
            ),
          ),
        );
      },
    );
  }
}
