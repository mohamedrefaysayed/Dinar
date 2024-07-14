// ignore_for_file: use_build_context_synchronously

import 'package:dinar_store/core/animations/top_slide_transition.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/adds_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/categories_view_home.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/companies_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/search_rows/search_row.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/search_view.dart';
import 'package:dinar_store/features/home/presentation/view_model/ads_cubit/ads_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/categories_cubit/categories_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/companies_cubit/companies_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<AdsCubit>().getAllAds();
        await context.read<CompaniesCubit>().getAllCompanies();
        await context.read<CategoriesCubit>().getAllCategories();
      },
      child: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
              child: Stack(
                children: [
                  Hero(
                    tag: "HomeSearch",
                    child: Material(
                      child: SearchRow(
                        textEditingController: TextEditingController(),
                        hintText: 'إبحث عن المتجر او القطعة',
                        canGoBack: false,
                        whenBack: () {},
                        haveFilter: true,
                        onFilter: () {},
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.w),
                      child: Material(
                        color: AppColors.kTransparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                TopSlideTransition(page: const SearchView()));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    const AddsView(),
                    const GeneralDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const CompaniesView(),
                    ),
                    const GeneralDivider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: const CategoriesViewHome(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
