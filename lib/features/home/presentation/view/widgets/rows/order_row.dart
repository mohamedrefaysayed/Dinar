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
  const OrderRow({super.key, required this.order});

  final DinarOrder order;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Text(
                context.read<OrderCubit>().getStatusMessage(order.status!),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 15.w,
                        color: AppColors.kASDCPrimaryColor,
                      ),
                    ],
                  ),
                  Text(
                    "x${order.orderDetails!.length}",
                    style: TextStyles.textStyle16.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.w,
                    ),
                  ),
                  Text(
                    MyTimeDate.getLastMessageTime(
                        context: context,
                        time: DateTime.parse(order.orderDate!)
                            .millisecondsSinceEpoch
                            .toString()),
                    style: TextStyles.textStyle18
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    order.address != null
                        ? "${order.address}"
                        : "لا يوجد عنوان",
                    style:
                        TextStyles.textStyle14.copyWith(color: AppColors.kGrey),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.orderDetails!.length < 3
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
            const GeneralDivider(),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        RightSlideTransition(
                            page: WholeOrderView(
                          order: ValueNotifier(order),
                        ),),);
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
