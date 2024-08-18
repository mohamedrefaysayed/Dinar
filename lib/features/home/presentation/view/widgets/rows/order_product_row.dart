import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderProductRow extends StatelessWidget {
  const OrderProductRow({
    super.key,
    required this.order,
    required this.index,
  });

  final DinarOrder order;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyCachedNetworkImage(
                height: 30.w,
                width: 30.w,
                fit: BoxFit.contain,
                url: (order.orderDetails![index].products != null &&
                        order.orderDetails![index].products!.image != null)
                    ? order.orderDetails![index].products!.image!
                    : "",
                errorIcon: const Icon(
                  Icons.image,
                  color: AppColors.primaryColor,
                ),
                loadingWidth: 10.w,
              ),
              SizedBox(
                width: 250.w,
                child: Text(
                  "${index + 1} - ${order.orderDetails![index].products!.productName} - ${order.orderDetails![index].units!.unitName} - * ${order.orderDetails![index].qty}",
                  textDirection: TextDirection.rtl,
                  style: TextStyles.textStyle14,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
