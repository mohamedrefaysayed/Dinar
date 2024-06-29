import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/old_orders_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/place_holders/all_companies_place_holder.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<OrderCubit>().getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<OrderCubit>().getAllOrders();
        },
        child: BlocConsumer<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderFailuer) {
              ScaffoldMessenger.of(context).showSnackBar(messageSnackBar(
                  message: state.errMessage, isBottomNavBar: true));
            }
            if (state is AddOrderFailuer) {
              ScaffoldMessenger.of(context).showSnackBar(messageSnackBar(
                  message: state.errMessage, isBottomNavBar: true));
            }
            if (state is DeleteOrderSuccess) {
              OrderCubit.ordersModel = state.ordersModel;
              ScaffoldMessenger.of(context).showSnackBar(
                  messageSnackBar(message: "تم الحذف", isBottomNavBar: true));
            }
            if (state is DeleteOrderFailuer) {
              ScaffoldMessenger.of(context).showSnackBar(messageSnackBar(
                  message: state.errMessage, isBottomNavBar: true));
            }
          },
          builder: (context, state) {
            if (state is OrderFailuer) {
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
            if (state is OrderLoading) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: const AllCompaniesPlaceHolder(),
              );
            }
            return (OrderCubit.ordersModel != null &&
                    (OrderCubit.ordersModel!.currentOrders!.isNotEmpty ||
                        OrderCubit.ordersModel!.oldOrders!.isNotEmpty))
                ? Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),
                        child: Text(
                          'الطلبــــــات',
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.w,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppDefaultButton(
                              width: 30.w,
                              height: 30.w,
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      (OrderCubit.ordersModel != null &&
                                              OrderCubit.ordersModel!.oldOrders!
                                                  .isNotEmpty)
                                          ? const OldOrdersView()
                                          : ListView(
                                              children: [
                                                SizedBox(
                                                  height: 300.h,
                                                ),
                                                Center(
                                                  child: Text(
                                                    "لا توجد طلبات سابقة",
                                                    style:
                                                        TextStyles.textStyle18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                );
                              },
                              title: '',
                              icon: Icon(
                                Icons.history,
                                size: 25.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const GeneralDivider(),
                      OrderCubit.ordersModel!.currentOrders!.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: OrderCubit
                                    .ordersModel!.currentOrders!.length,
                                itemBuilder: (context, index) {
                                  return OrderRow(
                                    order: OrderCubit
                                        .ordersModel!.currentOrders![index],
                                    isInDetails: false,
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: 300.h,
                                  ),
                                  Center(
                                    child: Text(
                                      "لا توجد طلبات",
                                      style: TextStyles.textStyle18,
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
                          "لا توجد طلبات",
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
