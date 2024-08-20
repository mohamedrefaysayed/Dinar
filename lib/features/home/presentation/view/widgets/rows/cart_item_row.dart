import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/cart_items_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemRow extends StatelessWidget {
  const CartItemRow({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          cartItem.isRetailed ? "مفرد" : "جملة",
          style: TextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.primaryColor,
            fontSize: 16.w,
          ),
          textDirection: TextDirection.rtl,
          maxLines: 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Column(
                  children: [
                    BlocConsumer<CartCubit, CartState>(
                      listener: (context, state) {
                        if (state is DeleteItemLoading) {
                        } else {
                          cartItem.loading = false;
                        }
                      },
                      builder: (context, state) {
                        if (cartItem.isRequired == 0) {
                          if (cartItem.loading) {
                            return SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                color: AppColors.kRed,
                              ),
                            );
                          } else {
                            return IconButton(
                              onPressed: () {
                                cartItem.loading = true;

                                context.read<CartCubit>().deleteItem(
                                      itemId: cartItem.id!,
                                    );
                              },
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                size: 25.w,
                                color: AppColors.primaryColor,
                              ),
                            );
                          }
                        } else {
                          return Text(
                            'فرض',
                            style: TextStyles.textStyle16.copyWith(
                              fontWeight: FontWeight.w200,
                              color: AppColors.kGrey,
                              fontSize: 16.w,
                            ),
                          );
                        }
                      },
                    ),
                    Text(
                      cartItem.unit!.unitName!,
                      style: TextStyles.textStyle16.copyWith(
                        fontWeight: FontWeight.w200,
                        color: AppColors.kGrey,
                        fontSize: 16.w,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    cartItem.isRequired == 0
                        ? Row(
                            children: [
                              // AppDefaultButton(
                              //   color: AppColors.kLightGrey,
                              //   width: 27.w,
                              //   height: 27.w,
                              //   onPressed: () async {
                              //     if (double.parse(cartItem.quantity!).toInt() -
                              //             1 >
                              //         0) {
                              //       cartItem.updating = true;
                              //       await context.read<CartCubit>().updateItem(
                              //             itemId: cartItem.id!,
                              //             productId:
                              //                 int.parse(cartItem.productId!),
                              //             quantity:
                              //                 double.parse(cartItem.quantity!)
                              //                         .toInt() -
                              //                     1,
                              //             unitId: int.parse(cartItem.unitId!),
                              //             price: double.parse(cartItem.price!),
                              //             isRequired: cartItem.isRequired!,
                              //           );
                              //     }
                              //   },
                              //   title: '',
                              //   icon: Icon(
                              //     Icons.remove,
                              //     size: 20.w,
                              //   ),
                              // ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 37.w),
                                child: BlocConsumer<CartCubit, CartState>(
                                  listener: (context, state) {
                                    if (state is UpdateItemLoading) {
                                    } else {
                                      cartItem.updating = false;
                                    }
                                  },
                                  builder: (context, state) {
                                    if (cartItem.updating) {
                                      return SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: const CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      );
                                    }
                                    return Text(
                                      cartItem.quantity!.toString(),
                                      style: TextStyles.textStyle16.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.w,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // AppDefaultButton(
                              //   color: AppColors.kLightRed,
                              //   width: 27.w,
                              //   height: 27.w,
                              //   onPressed: () async {
                              //     cartItem.updating = true;
                              //     await context.read<CartCubit>().updateItem(
                              //           itemId: cartItem.id!,
                              //           productId:
                              //               int.parse(cartItem.productId!),
                              //           quantity:
                              //               double.parse(cartItem.quantity!)
                              //                       .toInt() +
                              //                   1,
                              //           unitId: int.parse(cartItem.unitId!),
                              //           price: double.parse(cartItem.price!),
                              //           isRequired: cartItem.isRequired!,
                              //         );
                              //   },
                              //   title: '',
                              //   icon: Icon(
                              //     Icons.add,
                              //     size: 20.w,
                              //     color: AppColors.kRed,
                              //   ),
                              // ),
                            ],
                          )
                        : Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 37.w),
                                child: Text(
                                  cartItem.quantity!.toString(),
                                  style: TextStyles.textStyle16.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cartItem.product!.productName!,
                          style: TextStyles.textStyle12.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          width: 100.w,
                          child: Text(
                            cartItem.product!.description!,
                            style: TextStyles.textStyle10.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "${(cartItem.isRetailed ? cartItem.product!.retailPrice : cartItem.product!.wholeSalePrice)}.د",
                          style: TextStyles.textStyle12.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryColor,
                            fontSize: 16.w,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          "م.ج : ${cartItem.price!}.د",
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryColor,
                            fontSize: 16.w,
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.w),
                      child: MyCachedNetworkImage(
                        width: 70.w,
                        height: 60.h,
                        fit: BoxFit.contain,
                        url: cartItem.product!.image!,
                        errorIcon: Icon(
                          Icons.image,
                          size: 25.w,
                          color: AppColors.primaryColor,
                        ),
                        loadingWidth: 10.w,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const GeneralDivider(),
      ],
    );
  }
}
