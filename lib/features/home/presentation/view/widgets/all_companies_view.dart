import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/companies_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/all_company_container.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/all_companies_place_holder.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/search_rows/search_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/companies_cubit/companies_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCompaniesView extends StatefulWidget {
  const AllCompaniesView({super.key, required this.companiesModel});

  final CompaniesModel companiesModel;

  @override
  State<AllCompaniesView> createState() => _AllCompaniesViewState();
}

class _AllCompaniesViewState extends State<AllCompaniesView> {
  @override
  void initState() {
    CompaniesCubit.companiesModel = widget.companiesModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CompaniesCubit>().getAllCompanies();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Row(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Text(
                      'الشركـــــــــــات',
                      style: TextStyles.textStyle16.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.w,
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Transform.flip(
                            flipX: true,
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryColor,
                              size: 30.w,
                            ))),
                  ],
                ),
              ),
              SearchRow(
                textEditingController: CompaniesCubit.companySearchController,
                hintText: 'قم بالبحث عن شركة',
                canGoBack: false,
                haveFilter: false,
                onChanged: (_) {
                  context.read<CompaniesCubit>().searchInSubCompanies();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                child: BlocConsumer<CompaniesCubit, CompaniesState>(
                  listener: (context, state) {
                    if (state is CompaniesSuccess) {
                      CompaniesCubit.companiesModel = state.companiesModel;
                    }
                  },
                  builder: (context, state) {
                    if (state is CompaniesSuccess) {
                      return CompaniesCubit.companySearchController.text.isEmpty
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: CompaniesCubit
                                  .companiesModel.companies!.length,
                              itemBuilder: (context, index) {
                                return AllCompanyContainer(
                                  company: CompaniesCubit
                                      .companiesModel.companies![index],
                                );
                              },
                            )
                          : CompaniesCubit
                                  .companiesSearchModel.companies!.isEmpty
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
                                  itemCount: CompaniesCubit
                                      .companiesSearchModel.companies!.length,
                                  itemBuilder: (context, index) {
                                    return AllCompanyContainer(
                                      company: CompaniesCubit
                                          .companiesSearchModel
                                          .companies![index],
                                    );
                                  },
                                );
                    }
                    return const AllCompaniesPlaceHolder();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
