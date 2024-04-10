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

class RequiredProductsShow extends StatelessWidget {
  const RequiredProductsShow({
    super.key,
    required this.product,
    required this.retailCount,
    required this.totalRetailPrice,
  });

  final Products product;
  final ValueNotifier<int> retailCount;
  final ValueNotifier<double> totalRetailPrice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 20.h),
      child: Column(
        children: [
          Text(
            "الفرض",
            style: TextStyles.textStyle18,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: product.requiredProducts!.length,
              itemBuilder: (context, index) {
                return RequierdProductContainer(
                    product: product.requiredProducts![index]);
              },
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppDefaultButton(
                color: AppColors.kASDCPrimaryColor,
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
                      color: AppColors.kASDCPrimaryColor,
                      textStyle: TextStyles.textStyle16.copyWith(
                        color: AppColors.kWhite,
                        fontSize: 16.w,
                      ),
                      width: 100.w,
                      onPressed: () async {
                        await context.read<CartCubit>().storeItem(
                              productId: product.id!,
                              quantity: retailCount.value,
                              unitId: int.parse(product.retailUnitId!),
                              price: totalRetailPrice.value,
                              isRequired: '0',
                              isLast: false,
                              requiredProducts: product.requiredProducts!,
                            );
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
