import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/functions/future_delayed_navigator.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/all_companies_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/company_container.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/companies_place_holder.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/products_view.dart';
import 'package:dinar_store/features/home/presentation/view_model/companies_cubit/companies_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompaniesView extends StatefulWidget {
  const CompaniesView({super.key});

  @override
  State<CompaniesView> createState() => _CompaniesViewState();
}

class _CompaniesViewState extends State<CompaniesView> {
  @override
  void initState() {
    context.read<CompaniesCubit>().getAllCompanies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<CompaniesCubit, CompaniesState>(
      listener: (context, state) {
        if (state is CompaniesFaliuer) {
          context.showMessageSnackBar(
            message: state.errMessage,
          );
        }
      },
      builder: (context, state) {
        if (state is CompaniesSuccess) {
          return SizedBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'الشركـــــــــــات',
                      style: TextStyles.textStyle16.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Wrap(
                  alignment: WrapAlignment.end,
                  runAlignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 10.w,
                  runSpacing: height / 3.3 / 20,
                  children: List.generate(
                    state.companiesModel.companies!.length < 8
                        ? state.companiesModel.companies!.length
                        : 8,
                    (index) {
                      if (state.companiesModel.companies!.length > 7 &&
                          index == 4) {
                        return CompanyContainer(
                          index: index,
                          isMore: true,
                          companyName: 'عرض المزيد',
                          onTap: () {
                            Navigator.push(
                                context,
                                RightSlideTransition(
                                    page: AllCompaniesView(
                                  companiesModel: state.companiesModel,
                                )));
                          },
                          heroId: 9999999,
                        );
                      }
                      return CompanyContainer(
                        index: index,
                        companyName:
                            state.companiesModel.companies![index].companyName!,
                        compantIconImage:
                            state.companiesModel.companies![index].logo!,
                        onTap: () {
                          futureDelayedNavigator(() {
                            Navigator.push(
                                context,
                                RightSlideTransition(
                                    page: ProductsView(
                                  company:
                                      state.companiesModel.companies![index],
                                  isCategory: false,
                                )));
                          });
                        },
                        heroId: state.companiesModel.companies![index].id!,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        if (state is CompaniesFaliuer) {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: Text(
                "حدثت مشكلة أثناء جلب الشركات",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.kGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return const CompaniesPlaceHolder();
      },
    );
  }
}
