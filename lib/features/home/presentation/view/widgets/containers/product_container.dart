import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/functions/future_delayed_navigator.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.product,
  });

  final Products product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.5.h),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.w),
              color: AppColors.kWhite,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Hero(
                      tag: "Product${product.id}",
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.w),
                        child: MyCachedNetworkImage(
                          // fit: BoxFit.contain,
                          height: 70.h,
                          width: 90.w,
                          url: product.image!,
                          errorIcon: Icon(
                            Icons.image,
                            size: 50.w,
                            color: AppColors.primaryColor,
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
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
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
                                    text: "${product.retailPrice!}.د, ",
                                    style: TextStyles.textStyle12.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${product.wholeSalePrice!}.د",
                                    style: TextStyles.textStyle12.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green),
                                  ),
                                ]),
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 45.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.w),
                        color: Colors.green.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          '4.8 #',
                          style: TextStyles.textStyle10,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                      width: 60.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.w),
                        color: Colors.red.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          'خصم %20',
                          style: TextStyles.textStyle10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            color: AppColors.kTransparent,
            child: InkWell(
              onTap: () {
                futureDelayedNavigator(
                  () {
                    Navigator.push(
                      context,
                      RightSlideTransition(
                        page: ProductView(
                          product: product,
                        ),
                      ),
                    );
                  },
                );
              },
              borderRadius: BorderRadius.circular(15.w),
              child: SizedBox(
                height: 70.w,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
