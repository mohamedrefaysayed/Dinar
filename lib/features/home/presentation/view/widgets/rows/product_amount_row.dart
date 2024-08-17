import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductAmountRow extends StatefulWidget {
  const ProductAmountRow({
    super.key,
    required this.retailPrice,
    required this.wholeSalePrice,
    required this.retailCount,
    required this.wholeCount,
    required this.totalRetailPrice,
    required this.totalWholePrice,
    required this.minRetail,
    required this.maxRetail,
    required this.minWhole,
    required this.maxWhole,
    required this.itemImage,
  });

  final String retailPrice;
  final String wholeSalePrice;
  final ValueNotifier<int> retailCount;
  final ValueNotifier<int> wholeCount;
  final ValueNotifier<double> totalRetailPrice;
  final ValueNotifier<double> totalWholePrice;
  final int minRetail;
  final int maxRetail;
  final int minWhole;
  final int maxWhole;
  final String itemImage;

  @override
  State<ProductAmountRow> createState() => _ProductAmountRowState();
}

class _ProductAmountRowState extends State<ProductAmountRow> {
  bool value = false;
  ValueNotifier<int> wholeSaleCounter = ValueNotifier<int>(0);
  ValueNotifier<int> retailCounter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${double.parse(widget.wholeSalePrice).toInt()}.د',
                          style: TextStyles.textStyle12.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryColor),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50.w,
                        child: Center(
                          child: AppDefaultButton(
                            color: AppColors.kLightGrey,
                            height: 22.w,
                            width: 22.w,
                            noFuture: true,
                            onPressed: () {
                              //  if (wholeSaleCounter.value >= widget.minWhole) {
                              //   wholeSaleCounter.value =
                              //       wholeSaleCounter.value - widget.minWhole;
                              //   widget.wholeCount.value =
                              //       widget.wholeCount.value - widget.minWhole;

                              //   widget.totalWholePrice.value =
                              //       (widget.totalWholePrice.value -
                              //           (double.parse(widget.wholeSalePrice) *
                              //               widget.minWhole));
                              // }
                              if (wholeSaleCounter.value > widget.minWhole) {
                                wholeSaleCounter.value--;
                                widget.wholeCount.value--;

                                widget.totalWholePrice.value = (widget
                                        .totalWholePrice.value -
                                    (double.parse(widget.wholeSalePrice) * 1));
                              } else {
                                if (wholeSaleCounter.value > 0) {
                                  wholeSaleCounter.value =
                                      wholeSaleCounter.value - widget.minWhole;
                                  widget.wholeCount.value =
                                      widget.wholeCount.value - widget.minWhole;

                                  widget.totalWholePrice.value =
                                      (widget.totalWholePrice.value -
                                          (double.parse(widget.wholeSalePrice) *
                                              widget.minWhole));
                                }
                              }
                            },
                            icon: Icon(
                              Icons.remove,
                              size: 20.w,
                            ),
                            title: '',
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: wholeSaleCounter,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return SizedBox(
                            width: 50.w,
                            child: Center(
                              child: Text(
                                wholeSaleCounter.value.toString(),
                                style: TextStyles.textStyle16.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.w,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Center(
                          child: AppDefaultButton(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            height: 22.w,
                            width: 22.w,
                            noFuture: true,
                            //    onPressed: () {
                            //   wholeSaleCounter.value =
                            //       wholeSaleCounter.value + widget.minWhole;
                            //   widget.wholeCount.value =
                            //       widget.wholeCount.value + widget.minWhole;
                            //   widget.totalWholePrice.value =
                            //       (widget.totalWholePrice.value +
                            //           (double.parse(widget.wholeSalePrice) *
                            //               widget.minWhole));
                            // },
                            onPressed: () {
                              if (wholeSaleCounter.value == 0) {
                                if (widget.wholeCount.value + widget.minWhole >
                                    widget.maxWhole) {
                                  context.showMessageSnackBar(
                                      message:
                                          "لا يمكنك طلب اكثر من ${widget.maxWhole} من هذا المنتج فى حالة الجملة");
                                } else {
                                  wholeSaleCounter.value =
                                      wholeSaleCounter.value + widget.minWhole;
                                  widget.wholeCount.value =
                                      widget.wholeCount.value + widget.minWhole;
                                  widget.totalWholePrice.value =
                                      (widget.totalWholePrice.value +
                                          (double.parse(widget.wholeSalePrice) *
                                              widget.minWhole));
                                }
                              } else {
                                if (widget.wholeCount.value + 1 >
                                    widget.maxWhole) {
                                  context.showMessageSnackBar(
                                      message:
                                          "لا يمكنك طلب اكثر من ${widget.maxWhole} من هذا المنتج فى حالة الجملة");
                                } else {
                                  wholeSaleCounter.value++;
                                  widget.wholeCount.value++;
                                  widget.totalWholePrice.value =
                                      (widget.totalWholePrice.value +
                                          (double.parse(widget.wholeSalePrice) *
                                              1));
                                }
                              }
                            },
                            icon: Icon(
                              Icons.add,
                              size: 20.w,
                              color: AppColors.primaryColor,
                            ),
                            title: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 90.w,
                    child: Text(
                      'الكمية بالجملة',
                      style: TextStyles.textStyle12.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${double.parse(widget.retailPrice).toInt()}.د',
                          style: TextStyles.textStyle12.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryColor,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 50.w,
                        child: Center(
                          child: AppDefaultButton(
                            color: AppColors.kLightGrey,
                            height: 22.w,
                            width: 22.w,
                            noFuture: true,
                            onPressed: () {
                              // if (retailCounter.value > 0) {
                              //   retailCounter.value--;
                              //   widget.retailCount.value--;
                              //   widget.totalRetailPrice.value =
                              //       (widget.totalRetailPrice.value -
                              //           double.parse(widget.retailPrice));
                              // }
                              if (retailCounter.value > widget.minRetail) {
                                retailCounter.value--;
                                widget.retailCount.value--;

                                widget.totalRetailPrice.value =
                                    (widget.totalRetailPrice.value -
                                        (double.parse(widget.retailPrice) * 1));
                              } else {
                                if (retailCounter.value > 0) {
                                  retailCounter.value =
                                      retailCounter.value - widget.minRetail;
                                  widget.retailCount.value =
                                      widget.retailCount.value -
                                          widget.minRetail;

                                  widget.totalRetailPrice.value =
                                      (widget.totalRetailPrice.value -
                                          (double.parse(widget.retailPrice) *
                                              widget.minRetail));
                                }
                              }
                            },
                            icon: Icon(
                              Icons.remove,
                              size: 20.w,
                            ),
                            title: '',
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: retailCounter,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return SizedBox(
                            width: 50.w,
                            child: Center(
                              child: Text(
                                retailCounter.value.toString(),
                                style: TextStyles.textStyle16.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.w,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 50.w,
                        child: Center(
                          child: AppDefaultButton(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            height: 22.w,
                            width: 22.w,
                            noFuture: true,
                            // onPressed: () {
                            //   retailCounter.value++;
                            //   widget.retailCount.value++;
                            //   widget.totalRetailPrice.value =
                            //       (widget.totalRetailPrice.value +
                            //           double.parse(widget.retailPrice));
                            // },
                            onPressed: () {
                              if (retailCounter.value == 0) {
                                if (retailCounter.value + widget.minRetail >
                                    widget.maxRetail) {
                                  context.showMessageSnackBar(
                                      message:
                                          "لا يمكنك طلب اكثر من ${widget.maxRetail} من هذا المنتج فى حالة المفرد");
                                } else {
                                  retailCounter.value =
                                      retailCounter.value + widget.minRetail;
                                  widget.retailCount.value =
                                      widget.retailCount.value +
                                          widget.minRetail;
                                  widget.totalRetailPrice.value =
                                      (widget.totalRetailPrice.value +
                                          (double.parse(widget.retailPrice) *
                                              widget.minRetail));
                                }
                              } else {
                                if (retailCounter.value + 1 >
                                    widget.maxRetail) {
                                  context.showMessageSnackBar(
                                      message:
                                          "لا يمكنك طلب اكثر من ${widget.maxRetail} من هذا المنتج فى حالة المفرد");
                                } else {
                                  retailCounter.value++;
                                  widget.retailCount.value++;
                                  widget.totalRetailPrice.value =
                                      (widget.totalRetailPrice.value +
                                          double.parse(widget.retailPrice));
                                }
                              }
                            },
                            icon: Icon(
                              Icons.add,
                              size: 20.w,
                              color: AppColors.primaryColor,
                            ),
                            title: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 90.w,
                    child: Text(
                      'الكمية بالمفرد',
                      style: TextStyles.textStyle12.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            width: 10.w,
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10.w),
          //   child: MyCachedNetworkImage(
          //     width: 60.w,
          //     height: 60.w,
          //     url: widget.itemImage,
          //     errorIcon: Icon(
          //       Icons.image,
          //       size: 20.w,
          //       color: AppColors.kASDCPrimaryColor,
          //     ),
          //     loadingWidth: 10.w,
          //   ),
          // ),
        ],
      ),
    );
  }
}
