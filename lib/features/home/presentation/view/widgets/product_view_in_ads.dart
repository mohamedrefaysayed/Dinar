// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously

import 'package:dinar_store/core/animations/left_slide_transition.dart';
import 'package:dinar_store/core/helpers/app_cache/cahch_helper.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/genrall.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/defult_scaffold.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/presentation/view/cart_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/required_products_show.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/product_amount_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/sub_category_products_cubit/sub_category_product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductViewInAdds extends StatefulWidget {
  const ProductViewInAdds({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  State<ProductViewInAdds> createState() => _ProductViewInAddsState();
}

class _ProductViewInAddsState extends State<ProductViewInAdds> {
  ValueNotifier<int> retailCount = ValueNotifier<int>(0);
  ValueNotifier<int> wholeCount = ValueNotifier<int>(0);
  ValueNotifier<double> totalRetailPrice = ValueNotifier<double>(0);
  ValueNotifier<double> totalWholePrice = ValueNotifier<double>(0);
  @override
  void initState() {
    super.initState();
    context.read<SubCategoryProductCubit>().getProduct(
          productId: widget.productId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefultScaffold(
      canPop: true,
      body: BlocBuilder<SubCategoryProductCubit, SubCategoryProductState>(
        builder: (context, state) {
          if (state is ProductSuccess) {
            Products product = state.products;

            return SizedBox(
              width: double.infinity,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 250.h,
                    ),
                    child: Hero(
                      tag: 'Product${product.id}',
                      child: MyCachedNetworkImage(
                        // fit: BoxFit.contain,
                        url: product.image!,
                        errorIcon: Icon(
                          Icons.image,
                          size: 150.w,
                          color: AppColors.primaryColor,
                        ),
                        loadingWidth: 13.w,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            product.productName!,
                            style: TextStyles.textStyle16.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.w,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            product.description!,
                            style: TextStyles.textStyle10.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${product.retailPrice!}.د , ",
                                    style: TextStyles.textStyle12.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  ),
                                  TextSpan(
                                    text: "${product.wholeSalePrice!}.د",
                                    style: TextStyles.textStyle16.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.green,
                                      fontSize: 16.w,
                                    ),
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const GeneralDivider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 30.w),
                      //   child: Text(
                      //     'النكهات',
                      //     style: TextStyles.textStyle16.copyWith(
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 16.w,
                      //     ),
                      //     overflow: TextOverflow.ellipsis,
                      //     textDirection: TextDirection.rtl,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      ProductAmountRow(
                        retailPrice: product.retailPrice!.toString(),
                        wholeSalePrice: product.wholeSalePrice!.toString(),
                        retailCount: retailCount,
                        wholeCount: wholeCount,
                        totalRetailPrice: totalRetailPrice,
                        totalWholePrice: totalWholePrice,
                        minRetail: product.minRetailQuantity!,
                        maxRetail: product.maxRetailQuantity!,
                        minWhole: product.minWholeQuantity!,
                        maxWhole: product.maxWholeQuantity!,
                        itemImage: product.image!,
                      ),
                    ],
                  ),
                  const GeneralDivider(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              'ملاحظات أخرى',
                              style: TextStyles.textStyle14
                                  .copyWith(fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextField(
                          maxLines: null,
                          textDirection: TextDirection.rtl,
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                              hintTextDirection: TextDirection.rtl,
                              hintText: 'اكتب ملاحظاتك',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.w),
                                  borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.05),
                                  ))),
                        ),
                      ],
                    ),
                  ),
                  const GeneralDivider(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: wholeCount,
                              builder: (BuildContext context, int value,
                                  Widget? child) {
                                return Text(
                                  value.toString(),
                                  style: TextStyles.textStyle14.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                );
                              },
                            ),
                            const Spacer(),
                            Text(
                              'الاعداد بالجملة',
                              style: TextStyles.textStyle14
                                  .copyWith(fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: retailCount,
                              builder: (BuildContext context, int value,
                                  Widget? child) {
                                return Text(
                                  value.toString(),
                                  style: TextStyles.textStyle14.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                );
                              },
                            ),
                            const Spacer(),
                            Text(
                              'الاعداد بالمفرد',
                              style: TextStyles.textStyle14
                                  .copyWith(fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Divider(
                          color: Colors.grey.shade200,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: totalWholePrice,
                              builder: (BuildContext context, double value,
                                  Widget? child) {
                                return Text(
                                  "$value.د",
                                  style: TextStyles.textStyle14.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                );
                              },
                            ),
                            const Spacer(),
                            Text(
                              'السعر بالجملة',
                              style: TextStyles.textStyle14
                                  .copyWith(fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: totalRetailPrice,
                              builder: (BuildContext context, double value,
                                  Widget? child) {
                                return Text(
                                  "$value.د",
                                  style: TextStyles.textStyle14.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryColor),
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                );
                              },
                            ),
                            const Spacer(),
                            Text(
                              'السعر بالمفرد',
                              style: TextStyles.textStyle14
                                  .copyWith(fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: BlocConsumer<CartCubit, CartState>(
                                listener: (context, state) {
                                  if (state is AddToCartSuccess) {
                                    cartNotEmpty.value = true;
                                    CahchHelper.saveData(
                                        key: "cartNotEmpty", value: true);
                                    context.showMessageSnackBar(
                                      message: "تمت الإضافة الى العربة",
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is AddToCartLoading) {
                                    return const AppLoadingButton();
                                  }
                                  return AppDefaultButton(
                                    color: AppColors.primaryColor,
                                    icon: Icon(
                                      Icons.shopping_cart_rounded,
                                      color: Colors.white,
                                      size: 20.w,
                                    ),
                                    onPressed: () async {
                                      if ((totalRetailPrice.value +
                                              totalWholePrice.value) >
                                          0) {
                                        if (product.requiredProducts != null &&
                                            product
                                                .requiredProducts!.isNotEmpty) {
                                          await showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return RequiredProductsShow(
                                                product: product,
                                                retailCount: retailCount,
                                                totalRetailPrice:
                                                    totalRetailPrice,
                                                wholeCount: wholeCount,
                                                totalWholePrice:
                                                    totalWholePrice,
                                              );
                                            },
                                          );
                                        } else {
                                          if (retailCount.value > 0) {
                                            await context
                                                .read<CartCubit>()
                                                .storeItem(
                                              isRetail: true,
                                              productId: product.id!,
                                              quantity: retailCount.value,
                                              unitId: product.retailUnitId!,
                                              price: totalRetailPrice.value,
                                              isRequired: '0',
                                              isLast: true,
                                              requiredProducts: [],
                                            );
                                          }

                                          if (wholeCount.value > 0) {
                                            await context
                                                .read<CartCubit>()
                                                .storeItem(
                                              isRetail: false,
                                              productId: product.id!,
                                              quantity: wholeCount.value,
                                              unitId: product.wholeUnitId!,
                                              price: totalWholePrice.value,
                                              isRequired: '0',
                                              isLast: true,
                                              requiredProducts: [],
                                            );
                                          }
                                        }
                                        context.read<CartCubit>().getAllItems();
                                      } else {
                                        context.showMessageSnackBar(
                                          message: "أختر الكمية",
                                        );
                                      }
                                    },
                                    title: 'إضافة',
                                    textStyle: TextStyles.textStyle12.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.w,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.w),
                                  ),
                                  child: Center(
                                    child: ValueListenableBuilder(
                                      valueListenable: totalRetailPrice,
                                      builder: (BuildContext context,
                                          double totalRetailPricevalue,
                                          Widget? child) {
                                        return ValueListenableBuilder(
                                          valueListenable: totalWholePrice,
                                          builder: (BuildContext context,
                                              double totalwholePricevalue,
                                              Widget? child) {
                                            return Text(
                                              'المجموع : ${totalRetailPricevalue + totalwholePricevalue}.د',
                                              style: TextStyles.textStyle14
                                                  .copyWith(
                                                fontSize: 14.w,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w400,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              textDirection: TextDirection.rtl,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(
              height: 500.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "جارى جلب منتج الإعلان ...",
                    style: TextStyles.textStyle16,
                  ),
                  SpinKitChasingDots(
                    color: AppColors.primaryColor,
                    size: 50.sp,
                  )
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: cartNotEmpty,
        builder: (BuildContext context, bool value, Widget? child) => value
            ? Stack(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        LeftSlideTransition(
                          page: const CartView(
                            canPop: true,
                          ),
                        ),
                      );
                    },
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.kWhite,
                      size: 30.sp,
                    ),
                  ),
                  Container(
                    height: 10.w,
                    width: 10.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.kRed,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
