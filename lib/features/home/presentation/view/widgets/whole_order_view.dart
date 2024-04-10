import 'dart:async';

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/utils/time_date_handler.dart';
import 'package:dinar_store/features/home/data/models/orders_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_product_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepper_a/stepper_a.dart';

class WholeOrderView extends StatefulWidget {
  const WholeOrderView({
    super.key,
    required this.order,
  });
  final DinarOrder order;

  @override
  State<WholeOrderView> createState() => _WholeOrderViewState();
}

class _WholeOrderViewState extends State<WholeOrderView> {
  StepperAController stepperAController = StepperAController();
  ValueNotifier<bool> idDetailed = ValueNotifier<bool>(false);
  Timer? timer;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      stepperAController.next(onTap: (int currentIndex) {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Stack(
              children: [
                Container(
                  height: 350.h,
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
                  child: GoogleMap(
                    markers: {
                      Marker(
                        markerId: const MarkerId('موقع المتجر'),
                        position: widget.order.address != null
                            ? LatLng(double.parse(widget.order.address!.lat!),
                                double.parse(widget.order.address!.lng!))
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
                      target: widget.order.address != null
                          ? LatLng(double.parse(widget.order.address!.lat!),
                              double.parse(widget.order.address!.lng!))
                          : const LatLng(28.8993468, 76.6250249),
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
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
              child: ValueListenableBuilder(
                valueListenable: idDetailed,
                builder: (BuildContext context, bool value, Widget? child) =>
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
                            value ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            size: 30.w,
                            color: AppColors.kASDCPrimaryColor,
                          ),
                          Text(
                            "x${widget.order.orderDetails!.length}",
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
                                        time: DateTime.parse(
                                                widget.order.orderDate!)
                                            .millisecondsSinceEpoch
                                            .toString()),
                                    style: TextStyles.textStyle18
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.order.address != null
                                        ? "${widget.order.address!.country!}/${widget.order.address!.city!}/${widget.order.address!.street!}/${widget.order.address!.building!}"
                                        : "لا يوجد عنوان",
                                    style: TextStyles.textStyle14
                                        .copyWith(color: AppColors.kGrey),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        widget.order.orderDetails!.length,
                                    itemBuilder: (context, index) =>
                                        OrderProductRow(
                                      order: widget.order,
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
                height: 350.h,
                child: StepperA(
                    stepperSize: Size(150.w, 350.h),
                    borderShape: BorderShape.rRect,
                    borderType: BorderType.straight,
                    stepperAxis: Axis.vertical,
                    lineType: LineType.dotted,
                    stepperBackgroundColor: Colors.transparent,
                    stepperAController: stepperAController,
                    stepHeight: 40,
                    stepWidth: 40,
                    stepBorder: true,
                    pageSwipe: false,
                    formValidation: true,
                    customSteps: const [
                      CustomSteps(
                        stepsIcon: Icons.done,
                        title: 'تم تأكيد الطلب',
                      ),
                      CustomSteps(
                        stepsIcon: Icons.menu,
                        title: 'قيد التحضير',
                      ),
                      CustomSteps(
                        stepsIcon: Icons.motorcycle,
                        title: 'قيد التوصيل',
                      ),
                      CustomSteps(
                        stepsIcon: Icons.done_all_rounded,
                        title: 'تم التوصيل',
                      ),
                    ],
                    step: StepA(
                        currentStepColor: AppColors.kASDCPrimaryColor,
                        completeStepColor:
                            AppColors.kASDCPrimaryColor.withOpacity(0.5),
                        inactiveStepColor: AppColors.kGrey,
                        // loadingWidget: CircularProgressIndicator(color: Colors.green,),
                        margin: const EdgeInsets.all(5)),
                    stepperBodyWidget: const [
                      Text('تم تأكيد الطلب'),
                      Text('قيد التحضير'),
                      Text('قيد التوصيل'),
                      Text('تم التوصيل'),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
