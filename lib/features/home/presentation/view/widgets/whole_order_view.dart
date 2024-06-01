import 'dart:async';

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/utils/time_date_handler.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_product_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepper_a/stepper_a.dart';

class WholeOrderView extends StatefulWidget {
  const WholeOrderView({
    super.key,
    required this.order,
  });
  final ValueNotifier<DinarOrder> order;

  @override
  State<WholeOrderView> createState() => _WholeOrderViewState();
}

class _WholeOrderViewState extends State<WholeOrderView> {
  StepperAController stepperAController = StepperAController();
  ValueNotifier<bool> idDetailed = ValueNotifier<bool>(false);
  Timer? timer;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      for (int i = 1; i < int.parse(widget.order.value.status!); i++) {
        stepperAController.next(onTap: (int currentIndex) {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<OrderCubit>().getAllOrders();
          },
          child: ValueListenableBuilder(
            valueListenable: widget.order,
            builder: (BuildContext context, DinarOrder order, Widget? child) =>
                ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Container(
                        height: 250.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.w),
                            border: Border.all(
                              color: AppColors.kASDCPrimaryColor,
                              width: 2.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kGrey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.w),
                          child: GoogleMap(
                            markers: {
                              Marker(
                                markerId: const MarkerId('موقع المتجر'),
                                position: order.location != null
                                    ? LatLng(
                                        context
                                            .read<OrderCubit>()
                                            .extractLatLng(order.location!)
                                            .first,
                                        context
                                            .read<OrderCubit>()
                                            .extractLatLng(order.location!)
                                            .last,
                                      )
                                    : const LatLng(28.8993468, 76.6250249),
                              )
                            },
                            myLocationEnabled: true,
                            liteModeEnabled: true,
                            compassEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            mapToolbarEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              zoom: 18,
                              target: order.location != null
                                  ? LatLng(
                                      context
                                          .read<OrderCubit>()
                                          .extractLatLng(order.location!)
                                          .first,
                                      context
                                          .read<OrderCubit>()
                                          .extractLatLng(order.location!)
                                          .last,
                                    )
                                  : const LatLng(28.8993468, 76.6250249),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Transform.flip(
                          flipX: true,
                          child: Icon(
                            Icons.arrow_back,
                            size: 25.w,
                            color: AppColors.kASDCPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
                  child: ValueListenableBuilder(
                    valueListenable: idDetailed,
                    builder:
                        (BuildContext context, bool value, Widget? child) =>
                            GestureDetector(
                      onTap: () {
                        idDetailed.value = !value;
                      },
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                value
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 30.w,
                                color: AppColors.kASDCPrimaryColor,
                              ),
                              value
                                  ? Text(
                                      "إضغط للغلق",
                                      style: TextStyles.textStyle10.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Text(
                                      "إضغط لعرض المنتجات",
                                      style: TextStyles.textStyle10.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              Text(
                                "x${order.orderDetails!.length}",
                                style: TextStyles.textStyle16.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.w,
                                ),
                              ),
                            ],
                          ),
                          value
                              ? Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.kASDCPrimaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15.w),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        MyTimeDate.getLastMessageTime(
                                            context: context,
                                            time:
                                                DateTime.parse(order.orderDate!)
                                                    .millisecondsSinceEpoch
                                                    .toString()),
                                        style: TextStyles.textStyle18.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        order.address != null
                                            ? "${order.address}"
                                            : "لا يوجد عنوان",
                                        style: TextStyles.textStyle14
                                            .copyWith(color: AppColors.kGrey),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: order.orderDetails!.length,
                                        itemBuilder: (context, index) =>
                                            OrderProductRow(
                                          order: order,
                                          index: index,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SizedBox(
                    height: 400.h,
                    child: StepperA(
                      stepperSize: Size(150.w, 400.h),
                      borderShape: BorderShape.rRect,
                      borderType: BorderType.straight,
                      stepperAxis: Axis.vertical,
                      lineType: LineType.dotted,
                      stepperBackgroundColor: Colors.transparent,
                      stepperAController: stepperAController,
                      stepHeight: 30,
                      stepWidth: 30,
                      stepBorder: true,
                      pageSwipe: false,
                      formValidation: true,
                      customSteps: [
                        CustomSteps(
                          stepsIcon: Icons.done,
                          title:
                              context.read<OrderCubit>().getStatusMessage("1"),
                        ),
                        CustomSteps(
                          stepsIcon: Icons.menu,
                          title:
                              context.read<OrderCubit>().getStatusMessage("2"),
                        ),
                        CustomSteps(
                          stepsIcon: Icons.motorcycle,
                          title:
                              context.read<OrderCubit>().getStatusMessage("3"),
                        ),
                        CustomSteps(
                          stepsIcon: Icons.done_all_rounded,
                          title:
                              context.read<OrderCubit>().getStatusMessage("4"),
                        ),
                      ],
                      step: StepA(
                          currentStepColor: AppColors.kASDCPrimaryColor,
                          completeStepColor:
                              AppColors.kASDCPrimaryColor.withOpacity(0.5),
                          inactiveStepColor: AppColors.kGrey,
                          // loadingWidget: CircularProgressIndicator(color: Colors.green,),
                          margin: const EdgeInsets.all(5)),
                      stepperBodyWidget: [
                        Text(
                          context.read<OrderCubit>().getStatusMessage("1"),
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.w,
                          ),
                        ),
                        Text(
                          context.read<OrderCubit>().getStatusMessage("2"),
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.w,
                          ),
                        ),
                        Text(
                          context.read<OrderCubit>().getStatusMessage("3"),
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.w,
                          ),
                        ),
                        Text(
                          context.read<OrderCubit>().getStatusMessage("4"),
                          style: TextStyles.textStyle16.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
