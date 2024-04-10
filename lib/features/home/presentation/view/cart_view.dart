import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/presentation/view/order_confirm_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/all_companies_place_holder.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/cart_item_row.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/discount_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<CartCubit>().getAllItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CartCubit>().getAllItems();
        },
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is GetCartFailuer) {
              ScaffoldMessenger.of(context).showSnackBar(messageSnackBar(
                  message: state.errMessage, isBottomNavBar: true));
            }
            if (state is DeleteItemFailuer) {
              ScaffoldMessenger.of(context).showSnackBar(messageSnackBar(
                  message: state.errMessage, isBottomNavBar: true));
            }
            if (state is UpdateItemFailuer) {
              ScaffoldMessenger.of(context).showSnackBar(messageSnackBar(
                  message: state.errMessage, isBottomNavBar: true));
            }
            if (state is DeleteItemSuccess) {
              CartCubit.cartItemsModel = state.cartItemsModel;
              ScaffoldMessenger.of(context).showSnackBar(
                  messageSnackBar(message: "تم الحذف", isBottomNavBar: true));
            }
            if (state is UpdateItemSuccess) {
              CartCubit.cartItemsModel = state.cartItemsModel;
            }
          },
          builder: (context, state) {
            if (state is GetCartLoading) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),
                      child: Row(
                        children: [
                          const Spacer(
                            flex: 3,
                          ),
                          Text(
                            'ســــــلة المشــــــتريات',
                            style: TextStyles.textStyle16.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.w,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                    const GeneralDivider(),
                    const Expanded(child: AllCompaniesPlaceHolder()),
                  ],
                ),
              );
            }
            if (state is GetCartFailuer) {
              return ListView(
                children: [
                  SizedBox(
                    height: 300.h,
                    child: Center(
                      child: Text(
                        "حدث خطأ",
                        style: TextStyles.textStyle16.copyWith(
                          fontSize: 16.w,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return (CartCubit.cartItemsModel != null &&
                    CartCubit.cartItemsModel!.cart!.isNotEmpty)
                ? Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 35.w,
                              height: 35.w,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      height: 15.w,
                                      width: 15.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.kASDCPrimaryColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          CartCubit.cartItemsModel!.cart!.length
                                              .toString(),
                                          style: TextStyles.textStyle10
                                              .copyWith(
                                                  color: AppColors.kWhite),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 25.w,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            Text(
                              'ســــــلة المشــــــتريات',
                              style: TextStyles.textStyle16.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.w,
                              ),
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                      const GeneralDivider(),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: [
                            ListView.builder(
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: CartCubit.cartItemsModel!.cart!.length,
                              itemBuilder: (context, index) {
                                return CartItemRow(
                                  cartItem:
                                      CartCubit.cartItemsModel!.cart![index],
                                );
                              },
                            ),
                            const DiscountRow(),
                            const GeneralDivider(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'اجمالي الطلب',
                                  style: TextStyles.textStyle16.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.w,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 20.h),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "\$${CartCubit.totalPrice}",
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'مجموع الشراء',
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.kASDCPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\$${CartCubit.totalDiscount}",
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.kRed,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'سعر الخصم',
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.kASDCPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '\$0.00',
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'سعر التوصيل',
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.kASDCPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '\$0.00',
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'رسوم الخدمة',
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.kASDCPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const GeneralDivider(),
                                  Row(
                                    children: [
                                      Text(
                                        "\$${CartCubit.finalPrice}",
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'السعر النهائى',
                                        style: TextStyles.textStyle14.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.kASDCPrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const GeneralDivider(),
                                  AppDefaultButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          RightSlideTransition(
                                              page: const OrderConfirmView()));
                                    },
                                    color: AppColors.kASDCPrimaryColor,
                                    title: "إتمام الطلب",
                                    textStyle: TextStyles.textStyle16.copyWith(
                                      color: AppColors.kWhite,
                                      fontSize: 16.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      SizedBox(
                        height: 300.h,
                      ),
                      Center(
                        child: Text(
                          "العربة فارغة",
                          style: TextStyles.textStyle18,
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
