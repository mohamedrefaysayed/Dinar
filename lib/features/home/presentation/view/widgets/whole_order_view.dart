import 'dart:async';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  int activeStep = 1;
  ValueNotifier<bool> idDetailed = ValueNotifier<bool>(false);
  Timer? timer;
  @override
  void initState() {
    super.initState();
    for (int i = 1; i < int.parse(widget.order.value.status!) - 1; ++i) {
      setState(() {
        activeStep++;
      });
    }
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
                          ],
                        ),
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
                              ? OrderRow(
                                  order: widget.order.value,
                                  isInDetails: true,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: EasyStepper(
                    activeStep: activeStep,
                    lineStyle: LineStyle(lineLength: 60.w),
                    stepShape: StepShape.rRectangle,
                    stepBorderRadius: 15,
                    borderThickness: 2,
                    stepRadius: 28,
                    finishedStepBorderColor: AppColors.kRed,
                    finishedStepTextColor: AppColors.kRed,
                    finishedStepBackgroundColor: AppColors.kLightRed,
                    activeStepIconColor: AppColors.kASDCPrimaryColor,
                    showLoadingAnimation: false,
                    steps: [
                      EasyStep(
                        customStep: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Opacity(
                            opacity: activeStep >= 0 ? 1 : 0.3,
                            child: Icon(
                              Icons.watch_later_outlined,
                              size: 40.sp,
                            ),
                          ),
                        ),
                        title: context.read<OrderCubit>().getStatusMessage('1'),
                      ),
                      EasyStep(
                        customStep: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Opacity(
                            opacity: activeStep >= 1 ? 1 : 0.3,
                            child: Icon(
                              Icons.food_bank_outlined,
                              size: 40.sp,
                            ),
                          ),
                        ),
                        title: context.read<OrderCubit>().getStatusMessage('2'),
                      ),
                      EasyStep(
                        customStep: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Opacity(
                            opacity: activeStep >= 2 ? 1 : 0.3,
                            child: Icon(
                              Icons.delivery_dining_outlined,
                              size: 40.sp,
                            ),
                          ),
                        ),
                        title: context.read<OrderCubit>().getStatusMessage('3'),
                      ),
                      EasyStep(
                        customStep: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Opacity(
                            opacity: activeStep >= 3 ? 1 : 0.3,
                            child: Icon(
                              Icons.done_all_rounded,
                              size: 40.sp,
                            ),
                          ),
                        ),
                        title: context.read<OrderCubit>().getStatusMessage('4'),
                      ),
                      EasyStep(
                        customStep: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Opacity(
                            opacity: activeStep >= 3 ? 1 : 0.3,
                            child: Icon(
                              Icons.remove_done_rounded,
                              size: 40.sp,
                            ),
                          ),
                        ),
                        title: context.read<OrderCubit>().getStatusMessage('5'),
                      ),
                      EasyStep(
                        customStep: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Opacity(
                            opacity: activeStep >= 3 ? 1 : 0.3,
                            child: Icon(
                              Icons.running_with_errors_rounded,
                              size: 40.sp,
                            ),
                          ),
                        ),
                        title: context.read<OrderCubit>().getStatusMessage('6'),
                      ),
                    ],
                    onStepReached: (index) =>
                        setState(() => activeStep = index),
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
