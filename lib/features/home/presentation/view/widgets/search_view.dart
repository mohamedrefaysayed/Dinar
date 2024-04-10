// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/grid_views/categories_search_grid_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/grid_views/companies_search_grid_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/grid_views/products_search_grid_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/search_rows/search_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/search_cubit/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    context.read<SearchCubit>().search(keyWord: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<SearchCubit>().search(keyWord: "");
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Hero(
                  tag: "HomeSearch",
                  child: Material(
                    child: SearchRow(
                      textEditingController: SearchCubit.searchController,
                      hintText: 'إبحث عن المتجر او القطعة',
                      canGoBack: false,
                      onChanged: (newKeyWord) {
                        context.read<SearchCubit>().search(keyWord: newKeyWord);
                      },
                      haveFilter: true,
                      onFilter: () {
                        showModalBottomSheet(
                            constraints: BoxConstraints(
                              maxHeight: 200.h,
                            ),
                            context: context,
                            builder: (context) => StatefulBuilder(
                                  builder: (BuildContext context,
                                          void Function(void Function())
                                              setState) =>
                                      Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 15.h),
                                    child: ValueListenableBuilder(
                                      valueListenable: SearchCubit.filter,
                                      builder: (context, filter, child) =>
                                          Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "الشركــــــات",
                                                style: TextStyles.textStyle16
                                                    .copyWith(
                                                  fontSize: 16.w,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Checkbox(
                                                value: filter["companies"],
                                                onChanged: (value) {
                                                  SearchCubit.filter
                                                          .value["companies"] =
                                                      !SearchCubit.filter
                                                          .value["companies"]!;
                                                  context
                                                      .read<SearchCubit>()
                                                      .emit(SearchSuccess(
                                                          searchModel: SearchCubit
                                                              .searchModel!));

                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "المجموعــــــات",
                                                style: TextStyles.textStyle16
                                                    .copyWith(
                                                  fontSize: 16.w,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Checkbox(
                                                value: filter["categories"],
                                                onChanged: (value) {
                                                  SearchCubit.filter
                                                          .value["categories"] =
                                                      !SearchCubit.filter
                                                          .value["categories"]!;
                                                  context
                                                      .read<SearchCubit>()
                                                      .emit(SearchSuccess(
                                                          searchModel: SearchCubit
                                                              .searchModel!));

                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "المنتجــــــات",
                                                style: TextStyles.textStyle16
                                                    .copyWith(
                                                  fontSize: 16.w,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Checkbox(
                                                value: filter["products"],
                                                onChanged: (value) {
                                                  SearchCubit.filter
                                                          .value["products"] =
                                                      !SearchCubit.filter
                                                          .value["products"]!;
                                                  context
                                                      .read<SearchCubit>()
                                                      .emit(SearchSuccess(
                                                          searchModel: SearchCubit
                                                              .searchModel!));

                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return SizedBox(
                        width: double.infinity,
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 300.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: AppColors.kASDCPrimaryColor,
                                  ),
                                  Text(
                                    "جارى البحث ...",
                                    style: TextStyles.textStyle18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is SearchSuccess) {
                      if (state.searchModel.categories!.isEmpty &&
                          state.searchModel.companies!.isEmpty &&
                          state.searchModel.products!.isEmpty) {
                        return ListView(
                          children: [
                            SizedBox(
                              height: 300.h,
                              child: Center(
                                child: Text(
                                  "لا توجد",
                                  style: TextStyles.textStyle18,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        if (!SearchCubit.filter.value["companies"]! &&
                            !SearchCubit.filter.value["categories"]! &&
                            !SearchCubit.filter.value["products"]!) {
                          return ListView(
                            children: [
                              SizedBox(
                                height: 300.h,
                                child: Center(
                                  child: Text(
                                    "لا توجد",
                                    style: TextStyles.textStyle18,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return ListView(
                            children: [
                              if (state.searchModel.companies!.isNotEmpty &&
                                  SearchCubit.filter.value["companies"]!)
                                CompaniesSearchGridView(
                                  companies: state.searchModel.companies!,
                                ),
                              if (state.searchModel.categories!.isNotEmpty &&
                                  SearchCubit.filter.value["categories"]!)
                                CategoriesSearchGridView(
                                  categories: state.searchModel.categories!,
                                ),
                              if (state.searchModel.products!.isNotEmpty &&
                                  SearchCubit.filter.value["products"]!)
                                ProductsSearchGridView(
                                  products: state.searchModel.products!,
                                ),
                            ],
                          );
                        }
                      }
                    }
                    return ListView(
                      children: [
                        SizedBox(
                          height: 300.h,
                          child: Center(
                            child: Text(
                              "حدث خطأ",
                              style: TextStyles.textStyle18,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
