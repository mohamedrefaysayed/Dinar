// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/listviews/whole_sub_category_list_view.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_category_products_cubit/sub_category_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WholeSubCategoryViewNew extends StatefulWidget {
  const WholeSubCategoryViewNew({
    super.key,
    required this.subCategory,
    required this.subCategories,
  });

  final SubCategories subCategory;
  final List<SubCategories> subCategories;

  @override
  State<WholeSubCategoryViewNew> createState() =>
      _WholeSubCategoryViewNewState();
}

class _WholeSubCategoryViewNewState extends State<WholeSubCategoryViewNew>
    with SingleTickerProviderStateMixin {
  ValueNotifier<ScrollController> scrollController = ValueNotifier(
    ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true),
  );
  int initialIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    for (int i = 0; i < widget.subCategories.length; i++) {
      if (widget.subCategories[i].id == widget.subCategory.id) {
        initialIndex = i;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.subCategories.length,
      initialIndex: initialIndex,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              primary: false,
              floating: true,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
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
                          fontWeight: FontWeight.w400, color: Colors.grey),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                  onTap: (index) {
                    context
                        .read<SubCategoryProductCubit>()
                        .getSubCategoryWithProduct(
                            catId: widget.subCategories[index].id!);
                  },
                  tabs: List.generate(
                      widget.subCategories.length,
                      (index) => Tab(
                            height: 60.h,
                            child: Text(
                              widget.subCategories[index].categoryName!,
                              style: TextStyles.textStyle14,
                            ),
                          ))),
            )
          ],
          body: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<SubCategoryProductCubit>()
                  .getSubCategoryWithProduct(catId: widget.subCategory.id!);
            },
            child: Column(
              children: [
                Hero(
                  tag: 'SubCat${widget.subCategory.id}',
                  child: MyCachedNetworkImage(
                    url: widget.subCategory.image!,
                    width: double.infinity,
                    errorIcon: Icon(
                      Icons.image,
                      size: 150.w,
                      color: AppColors.primaryColor,
                    ),
                    loadingWidth: 13.w,
                  ),
                ),
                const GeneralDivider(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          widget.subCategories.length,
                          (index) => WholeSubCategoryListView(
                            scrollController: scrollController,
                            subCategory: widget.subCategories[index],
                          ),
                        )),
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
