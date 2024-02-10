import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequierdProductContainer extends StatelessWidget {
  const RequierdProductContainer({
    super.key,
    required this.product,
  });

  final RequiredProducts product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.w),
          color: AppColors.kWhite,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text("${double.parse(product.pivot!.quantity!).toInt()} X"),
                Hero(
                  tag: "Product${product.id}",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.w),
                    child: MyCachedNetworkImage(
                      fit: BoxFit.contain,
                      height: 50.h,
                      width: 70.w,
                      url: product.image!,
                      errorIcon: Icon(
                        Icons.image,
                        size: 50.w,
                        color: AppColors.kASDCPrimaryColor,
                      ),
                      loadingWidth: 30.w,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          product.productName!,
                          style: TextStyles.textStyle12
                              .copyWith(fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          product.description!,
                          style: TextStyles.textStyle10.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: "\$${product.retailPrice}, ",
                                style: TextStyles.textStyle12.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green),
                              ),
                              TextSpan(
                                text: "\$${product.vipPrice}",
                                style: TextStyles.textStyle12.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              ),
                            ]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
