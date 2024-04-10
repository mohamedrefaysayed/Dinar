import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OldOrdersView extends StatelessWidget {
  const OldOrdersView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),
          child: Text(
            'الطلبــــــات الســــــابقة',
            style: TextStyles.textStyle16.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16.w,
            ),
          ),
        ),
        const GeneralDivider(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: OrderCubit.ordersModel!.oldOrders!.length,
            itemBuilder: (context, index) {
              return OrderRow(order: OrderCubit.ordersModel!.oldOrders![index]);
            },
          ),
        ),
      ],
    );
  }
}
