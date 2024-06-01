import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/product_container.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/products_place_holder.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_category_products_cubit/sub_category_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WholeSubCategoryListView extends StatelessWidget {
  const WholeSubCategoryListView({
    super.key,
    required this.scrollController,
    required this.subCategory,
  });

  final ValueNotifier<ScrollController> scrollController;
  final SubCategories subCategory;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoryProductCubit, SubCategoryProductState>(
      builder: (context, state) {
        if (state is SubCategoryProductLoading) {
          return const ProductsPlaceHolder();
        }
        if (state is SubCategoryProductFaliuer) {
          return Center(child: Text(state.errMessage));
        }
        return SubCategoryProductCubit.subCategoriesController.text.isEmpty
            ? SubCategoryProductCubit.subCategoryProductsModel.products!.isEmpty
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 150.h,
                        child: Center(
                          child: Text(
                            'لا يوجد عناصر',
                            style: TextStyles.textStyle14
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController.value,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: SubCategoryProductCubit
                        .subCategoryProductsModel.products!.length,
                    itemBuilder: (context, index) {
                      return ProductContainer(
                        product: SubCategoryProductCubit
                            .subCategoryProductsModel.products![index],
                      );
                    },
                  )
            : SubCategoryProductCubit
                    .subCategoryProductsModelSearch.products!.isEmpty
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 150.h,
                        child: Center(
                          child: Text(
                            'لا يوجد',
                            style: TextStyles.textStyle14
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: SubCategoryProductCubit
                        .subCategoryProductsModelSearch.products!.length,
                    itemBuilder: (context, index) {
                      return ProductContainer(
                        product: SubCategoryProductCubit
                            .subCategoryProductsModelSearch.products![index],
                      );
                    },
                    addAutomaticKeepAlives: true,
                  );
      },
    );
  }
}
