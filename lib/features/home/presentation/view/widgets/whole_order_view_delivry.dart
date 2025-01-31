// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WholeOrderViewDelivry extends StatefulWidget {
  const WholeOrderViewDelivry({
    super.key,
    required this.order,
    required this.isInOld,
  });
  final DinarOrder order;
  final bool isInOld;

  @override
  State<WholeOrderViewDelivry> createState() => _WholeOrderViewDelivryState();
}

class _WholeOrderViewDelivryState extends State<WholeOrderViewDelivry> {
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
                                  isDelivery: true,
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!widget.isInOld)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: AppDefaultButton(
                          color: AppColors.primaryColor,
                          height: 48.w,
                          onPressed: () {
                            launchUrlString(widget.order.location!);
                          },
                          title: 'أذهب للموقع',
                          icon: Icon(
                            Icons.location_on_outlined,
                            size: 25.w,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                     
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
