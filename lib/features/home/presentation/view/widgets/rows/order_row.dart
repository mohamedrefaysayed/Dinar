import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/utils/time_date_handler.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_product_row.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/whole_order_view.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderRow extends StatelessWidget {
  const OrderRow({
    super.key,
    required this.order,
    required this.isInDetails,
    required this.isInOld,
  });

  final DinarOrder order;
  final bool isInDetails;
  final bool isInOld;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isInDetails
            ? AppColors.primaryColor.withOpacity(0.1)
            : AppColors.kWhite,
        borderRadius: BorderRadius.circular(15.w),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  context
                      .read<OrderCubit>()
                      .getStatusMessage(order.status!.toString()),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isInDetails ? 0 : 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 15.w,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "رقم الطلب : ${order.id}",
                      style: TextStyles.textStyle16.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${order.orderDetails!.length} x منتجات",
                      style: TextStyles.textStyle16.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.w,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "تم الطلب : ${MyTimeDate.getMessageTime(
                        context: context,
                        time: DateTime.parse(order.createdAt!)
                            .toLocal()
                            .millisecondsSinceEpoch
                            .toString(),
                      )}",
                      style: TextStyles.textStyle16.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (order.deliveryTime != null) ...[
                      Text(
                        "يصل : ${MyTimeDate.getMessageTime(
                          context: context,
                          time: DateTime.parse(order.deliveryTime!)
                              .toLocal()
                              .millisecondsSinceEpoch
                              .toString(),
                        )}",
                        style: TextStyles.textStyle16.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                    Text(
                      order.address != null
                          ? "${order.address}"
                          : "لا يوجد عنوان",
                      style: TextStyles.textStyle14.copyWith(
                        color: AppColors.kGrey,
                      ),
                      softWrap: true,
                      maxLines: 5,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (order.orderDetails!.length < 3 || isInDetails)
                          ? order.orderDetails!.length
                          : 3,
                      itemBuilder: (context, index) => OrderProductRow(
                        order: order,
                        index: index,
                      ),
                    ),
                    if (order.orderDetails!.length > 3)
                      Text(
                        ".............................. والمزيد ",
                        style: TextStyles.textStyle14
                            .copyWith(color: AppColors.kGrey),
                      ),
                  ],
                ),
              ),
              if (!isInDetails) const GeneralDivider(),
            ],
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.w),
                child: Material(
                  color: AppColors.kTransparent,
                  child: InkWell(
                    onTap: !isInDetails
                        ? () {
                            Navigator.push(
                              context,
                              RightSlideTransition(
                                page: WholeOrderView(
                                  order: order,
                                  isInOld: isInOld,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
