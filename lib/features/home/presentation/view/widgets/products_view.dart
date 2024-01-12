// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/data/models/companies_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/sub_category_product_container.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/search_rows/search_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_category_products_cubit/sub_category_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({
    super.key,
    this.subcategory,
    this.company,
    required this.isCategory,
  });

  final SubCategories? subcategory;
  final Companies? company;
  final bool isCategory;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  void initState() {
    if (widget.isCategory) {
      context
          .read<SubCategoryProductCubit>()
          .getSubCategoryWithProduct(catId: widget.subcategory!.id!);
    } else {
      context
          .read<SubCategoryProductCubit>()
          .getCompanyWithProduct(companyId: widget.company!.id!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        SubCategoryProductCubit.subCategoriesController.clear();
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            if (widget.isCategory) {
              context
                  .read<SubCategoryProductCubit>()
                  .getSubCategoryWithProduct(catId: widget.subcategory!.id!);
            } else {
              context
                  .read<SubCategoryProductCubit>()
                  .getCompanyWithProduct(companyId: widget.company!.id!);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: 50.h, right: 20.w, left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SearchRow(
                  textEditingController:
                      SubCategoryProductCubit.subCategoriesController,
                  hintText: 'ابحث عن المنتج',
                  canGoBack: true,
                  whenBack: () {
                    Navigator.pop(context);
                  },
                  haveFilter: true,
                  onFilter: () {},
                  onChanged: (val) {
                    context.read<SubCategoryProductCubit>().searchInProducts();
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  widget.isCategory
                      ? widget.subcategory!.categoryName!
                      : widget.company!.companyName!,
                  style: TextStyles.textStyle18
                      .copyWith(fontWeight: FontWeight.w700),
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  widget.isCategory
                      ? widget.subcategory!.description!
                      : widget.company!.description!,
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
                      BlocConsumer<SubCategoryProductCubit,
                          SubCategoryProductState>(
                        listener: (context, state) {
                          if (state is SubCategoryProductSuccess) {
                            SubCategoryProductCubit.subCategoryProductsModel =
                                state.subCategoryProductsModel;
                          }
                        },
                        builder: (context, state) {
                          if (state is SubCategoryProductSuccess) {
                            return SubCategoryProductCubit
                                    .subCategoriesController.text.isEmpty
                                ? SubCategoryProductCubit
                                        .subCategoryProductsModel
                                        .products!
                                        .isEmpty
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
                                    : ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: SubCategoryProductCubit
                                            .subCategoryProductsModel
                                            .products!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return ProductContainer(
                                            product: SubCategoryProductCubit
                                                .subCategoryProductsModel
                                                .products![index],
                                          );
                                        },
                                      )
                                : SubCategoryProductCubit
                                        .subCategoryProductsModelSearch
                                        .products!
                                        .isEmpty
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
                                    : ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: SubCategoryProductCubit
                                            .subCategoryProductsModel
                                            .products!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return ProductContainer(
                                            product: SubCategoryProductCubit
                                                .subCategoryProductsModel
                                                .products![index],
                                          );
                                        },
                                        addAutomaticKeepAlives: true,
                                      );
                          }

                          return Shimmer.fromColors(
                            baseColor: Colors.grey.withOpacity(0.3),
                            highlightColor:
                                AppColors.kASDCPrimaryColor.withOpacity(0.5),
                            child: Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15.w)),
                                  );
                                },
                              ),
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
