import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/functions/future_delayed_navigator.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/companies_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllCompanyContainer extends StatelessWidget {
  const AllCompanyContainer({
    super.key,
    required this.company,
  });

  final Companies company;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.5.h),
      child: Stack(
        children: [
          Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(15.w),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1.w,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          company.companyName!,
                          style: TextStyles.textStyle14
                              .copyWith(fontWeight: FontWeight.w700),
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          company.description!,
                          style: TextStyles.textStyle10.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.grey),
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Hero(
                    tag: "Company${company.id}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.w),
                      child: MyCachedNetworkImage(
                        height: 35.w,
                        width: 35.w,
                        url: company.logo!,
                        errorIcon: Icon(
                          Icons.home_work_rounded,
                          size: 30.w,
                          color: AppColors.primaryColor,
                        ),
                        loadingWidth: 13.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: AppColors.kTransparent,
            child: InkWell(
              onTap: () {
                futureDelayedNavigator(() {
                  Navigator.push(
                      context,
                      RightSlideTransition(
                          page: ProductsView(
                        company: company,
                        isCategory: false,
                      )));
                });
              },
              borderRadius: BorderRadius.circular(15.w),
              child: SizedBox(
                height: 60.w,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
