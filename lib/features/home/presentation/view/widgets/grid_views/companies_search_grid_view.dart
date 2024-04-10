import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/companies_model.dart';
import 'package:dinar_store/features/home/data/models/search_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/products_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/search_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompaniesSearchGridView extends StatelessWidget {
  const CompaniesSearchGridView({super.key, required this.companies});

  final List<SearchCompany> companies;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GeneralDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "الشركــــــات",
              style: TextStyles.textStyle16.copyWith(
                fontSize: 16.w,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const GeneralDivider(),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: companies.length,
          itemBuilder: (context, index) => SearchItem(
            imag: companies[index].logo!,
            name: companies[index].companyName!,
            onTap: () {
              Map<String, dynamic> data = companies[index].toJson();
              Navigator.push(
                  context,
                  RightSlideTransition(
                      page: ProductsView(
                    isCategory: false,
                    company: Companies.fromJson(data),
                  )));
            },
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            childAspectRatio: 115.h / 135.w,
          ),
        ),
      ],
    );
  }
}
