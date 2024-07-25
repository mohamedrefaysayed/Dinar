// ignore_for_file: use_build_context_synchronously

import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/data/services/cart_services.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/containers/required_product_container.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequiredProductsShow extends StatefulWidget {
  const RequiredProductsShow({
    super.key,
    required this.product,
    required this.retailCount,
    required this.totalRetailPrice,
    required this.wholeCount,
    required this.totalWholePrice,
  });

  final Products product;
  final ValueNotifier<int> retailCount;
  final ValueNotifier<double> totalRetailPrice;
  final ValueNotifier<int> wholeCount;
  final ValueNotifier<double> totalWholePrice;

  @override
  State<RequiredProductsShow> createState() => _RequiredProductsShowState();
}

class _RequiredProductsShowState extends State<RequiredProductsShow> {
  List<RequiredProducts> retailRequiredProducts = [];
  List<RequiredProducts> wholeRequiredProducts = [];

  @override
  void initState() {
    for (var element in widget.product.requiredProducts!) {
      if (element.pivot!.unitId == widget.product.retailUnitId) {
        retailRequiredProducts.add(element);
      } else {
        wholeRequiredProducts.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 20.h),
      child: Column(
        children: [
          Text(
            "الفرض",
            style: TextStyles.textStyle18.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (widget.retailCount.value > 0)
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "المفرد ${widget.retailCount.value}",
                    style: TextStyles.textStyle14,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: retailRequiredProducts.length,
                      itemBuilder: (context, index) {
                        return RequierdProductContainer(
                          product: retailRequiredProducts[index],
                          retailUnitName: widget.product.retailUnit!.unitName!,
                          wholeUnitName: widget.product.wholeUnit!.unitName!,
                          retailCount: widget.retailCount,
                          wholeCount: widget.wholeCount,
                          isRetail: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (widget.wholeCount.value > 0)
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "الجملة ${widget.wholeCount.value}",
                    style: TextStyles.textStyle14,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: wholeRequiredProducts.length,
                      itemBuilder: (context, index) {
                        return RequierdProductContainer(
                          product: wholeRequiredProducts[index],
                          retailUnitName: widget.product.retailUnit!.unitName!,
                          wholeUnitName: widget.product.wholeUnit!.unitName!,
                          retailCount: widget.retailCount,
                          wholeCount: widget.wholeCount,
                          isRetail: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppDefaultButton(
                color: AppColors.primaryColor,
                textStyle: TextStyles.textStyle16.copyWith(
                  color: AppColors.kWhite,
                  fontSize: 16.w,
                ),
                width: 100.w,
                onPressed: () async {
                  Navigator.pop(context);
                },
                title: 'الغاء',
              ),
              BlocProvider(
                create: (context) => CartCubit(
                    cartServices: CartServices(dioHelper: DioHelper())),
                child: BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {
                    if (state is AddToCartFailuer) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          messageSnackBar(message: state.errMessage));
                    }
                    if (state is AddToCartSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          messageSnackBar(message: "تمت الإضافة الى العربة"));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is AddToCartLoading) {
                      return AppLoadingButton(
                        width: 100.w,
                      );
                    }
                    return AppDefaultButton(
                      color: AppColors.primaryColor,
                      textStyle: TextStyles.textStyle16.copyWith(
                        color: AppColors.kWhite,
                        fontSize: 16.w,
                      ),
                      width: 100.w,
                      onPressed: () async {
                        if (widget.retailCount.value > 0) {
                          CartCubit.retailIsDone = false;

                          await context.read<CartCubit>().storeItem(
                                productId: widget.product.id!,
                                quantity: widget.retailCount.value,
                                unitId: widget.product.retailUnitId!,
                                price: widget.totalRetailPrice.value,
                                isRequired: '0',
                                isLast: false,
                                requiredProducts: retailRequiredProducts,
                              );

                          CartCubit.retailIsDone = true;
                        }

                        if (widget.wholeCount.value > 0) {
                          CartCubit.wholeIsDone = false;

                          await context.read<CartCubit>().storeItem(
                                productId: widget.product.id!,
                                quantity: widget.wholeCount.value,
                                unitId: widget.product.wholeUnitId!,
                                price: widget.totalWholePrice.value,
                                isRequired: '0',
                                isLast: false,
                                requiredProducts: wholeRequiredProducts,
                              );

                          CartCubit.wholeIsDone = true;
                        }
                      },
                      title: 'موافق',
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
