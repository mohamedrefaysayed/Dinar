// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WholeOrderView extends StatefulWidget {
  const WholeOrderView({
    super.key,
    required this.order,
    required this.isInOld,
  });
  final DinarOrder order;
  final bool isInOld;

  @override
  State<WholeOrderView> createState() => _WholeOrderViewState();
}

class _WholeOrderViewState extends State<WholeOrderView> {
  ValueNotifier<int> activeStep = ValueNotifier(0);
  ValueNotifier<bool> isDetailed = ValueNotifier<bool>(false);
  Timer? timer;
  DinarOrder currentOrder = DinarOrder();

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
    for (int i = 0; i < int.parse(currentOrder.status!.toString()); i++) {
      activeStep.value = activeStep.value + 1;
    }
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        if (message.notification!.title!.contains(widget.order.id.toString())) {
          await context.read<OrderCubit>().getOrder(orderId: currentOrder.id!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<OrderCubit>()
                .getOrder(orderId: currentOrder.id!);
          },
          child: BlocListener<OrderCubit, OrderState>(
            listener: (context, state) {
              if (state is UpdateOrderSuccess) {
                currentOrder = state.order;
                activeStep.value = 0;

                for (int i = 0;
                    i < int.parse(currentOrder.status!.toString());
                    i++) {
                  activeStep.value = activeStep.value + 1;
                }
              }
              if (state is UpdateOrderFailuer) {
                context.showMessageSnackBar(
                  message: state.errMessage,
                );
              }
            },
            child: ListView(
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
                            color: AppColors.primaryColor,
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
                                position: currentOrder.location != null
                                    ? LatLng(
                                        context
                                            .read<OrderCubit>()
                                            .extractLatLng(
                                                currentOrder.location!)
                                            .first,
                                        context
                                            .read<OrderCubit>()
                                            .extractLatLng(
                                                currentOrder.location!)
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
                              target: currentOrder.location != null
                                  ? LatLng(
                                      context
                                          .read<OrderCubit>()
                                          .extractLatLng(currentOrder.location!)
                                          .first,
                                      context
                                          .read<OrderCubit>()
                                          .extractLatLng(currentOrder.location!)
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
                            color: AppColors.primaryColor,
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
                    valueListenable: isDetailed,
                    builder:
                        (BuildContext context, bool value, Widget? child) =>
                            GestureDetector(
                      onTap: () {
                        isDetailed.value = !value;
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
                                color: AppColors.primaryColor,
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
                                "x${currentOrder.orderDetails!.length}",
                                style: TextStyles.textStyle16.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.w,
                                ),
                              ),
                            ],
                          ),
                          value
                              ? OrderRow(
                                  order: currentOrder,
                                  isInDetails: true,
                                  isInOld: false,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: activeStep,
                  builder:
                      (BuildContext context, int currentStep, Widget? child) =>
                          Column(
                    children: [
                      Center(
                        child: Text(
                          context
                              .read<OrderCubit>()
                              .getStatusMessage(currentStep.toString()),
                          style: TextStyles.textStyle16,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: EasyStepper(
                            alignment: Alignment.centerRight,
                            direction: Axis.vertical,
                            activeStep: currentStep,
                            lineStyle: LineStyle(
                              lineType: LineType.normal,
                              lineLength: 20.h,
                              unreachedLineType: LineType.dotted,
                            ),
                            stepShape: StepShape.rRectangle,
                            stepBorderRadius: 15.r,
                            borderThickness: 2,
                            stepRadius: 28.r,
                            finishedStepBorderColor: AppColors.primaryColor,
                            finishedStepTextColor: AppColors.primaryColor,
                            finishedStepBackgroundColor: AppColors.primaryColor,
                            activeStepBorderColor:
                                AppColors.kBlack.withOpacity(0.7),
                            activeStepTextColor:
                                AppColors.kBlack.withOpacity(0.7),
                            activeStepBackgroundColor: AppColors.kGrey,
                            showLoadingAnimation: false,
                            showTitle: false,
                            steps: [
                              if (!widget.isInOld) ...[
                                EasyStep(
                                  customStep: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5.w,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(5.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Opacity(
                                        opacity: currentStep >= 0 ? 1 : 0.3,
                                        child: Icon(
                                          Icons.done,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: context
                                      .read<OrderCubit>()
                                      .getStatusMessage('0'),
                                ),
                                EasyStep(
                                  customStep: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5.w,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(5.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Opacity(
                                        opacity: currentStep >= 0 ? 1 : 0.3,
                                        child: Icon(
                                          Icons.watch_later_outlined,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: context
                                      .read<OrderCubit>()
                                      .getStatusMessage('1'),
                                ),
                                EasyStep(
                                  customStep: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5.w,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(5.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Opacity(
                                        opacity: currentStep >= 0 ? 1 : 0.3,
                                        child: Icon(
                                          Icons.fastfood,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: context
                                      .read<OrderCubit>()
                                      .getStatusMessage('2'),
                                ),
                                EasyStep(
                                  customStep: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 5.w,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(5.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Opacity(
                                        opacity: currentStep >= 0 ? 1 : 0.3,
                                        child: Icon(
                                          Icons.delivery_dining_rounded,
                                          size: 30.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: context
                                      .read<OrderCubit>()
                                      .getStatusMessage('3'),
                                ),
                              ],
                              if (widget.isInOld) ...[
                                if (int.parse(
                                        currentOrder.status!.toString()) ==
                                    4)
                                  EasyStep(
                                    customStep: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 5.w,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(5.w),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Opacity(
                                          opacity: currentStep >= 0 ? 1 : 0.3,
                                          child: Icon(
                                            Icons.done_all_rounded,
                                            size: 30.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: context
                                        .read<OrderCubit>()
                                        .getStatusMessage('4'),
                                  ),
                                if (int.parse(
                                        currentOrder.status!.toString()) ==
                                    5)
                                  EasyStep(
                                    customStep: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 5.w,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(5.w),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Opacity(
                                          opacity: currentStep >= 0 ? 1 : 0.3,
                                          child: Icon(
                                            Icons.remove_done_rounded,
                                            size: 30.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: context
                                        .read<OrderCubit>()
                                        .getStatusMessage('5'),
                                  ),
                                if (int.parse(currentOrder.status!.toString()) >
                                    5)
                                  EasyStep(
                                    customStep: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 5.w,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(5.w),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Opacity(
                                          opacity: currentStep >= 0 ? 1 : 0.3,
                                          child: Icon(
                                            Icons.running_with_errors_rounded,
                                            size: 30.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: context
                                        .read<OrderCubit>()
                                        .getStatusMessage('6'),
                                  ),
                              ],
                            ],
                            onStepReached: (index) =>
                                setState(() => currentStep = index),
                          ),
                        ),
                      ),
                    ],
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
