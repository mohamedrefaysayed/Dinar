import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/cachedNetworkImage/my_cached_nework_Image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequierdProductContainer extends StatefulWidget {
  const RequierdProductContainer({
    super.key,
    required this.product,
    required this.retailUnitName,
    required this.wholeUnitName,
    required this.retailCount,
    required this.wholeCount,
    required this.isRetail,
  });

  final RequiredProducts product;

  final String retailUnitName;
  final String wholeUnitName;
  final ValueNotifier<int> retailCount;
  final ValueNotifier<int> wholeCount;
  final bool isRetail;

  @override
  State<RequierdProductContainer> createState() =>
      _RequierdProductContainerState();
}

class _RequierdProductContainerState extends State<RequierdProductContainer> {
  double productCount = 0;

  @override
  void initState() {
    super.initState();

    if (widget.isRetail) {
      productCount = ((widget.retailCount.value /
                  ((widget.product.pivot!.quantity! * 1.0)))
              .floor() *
          (widget.product.pivot!.requiredQuantiy! * 1.0));
    } else {
      productCount =
          ((widget.wholeCount.value / ((widget.product.pivot!.quantity! * 1.0)))
                  .floor() *
              (widget.product.pivot!.requiredQuantiy! * 1.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.5.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.w),
          color: AppColors.kWhite,
        ),
        child: Column(
          children: [
            Text(
              "${widget.product.pivot!.requiredQuantiy!} فرض  لكل ${widget.product.pivot!.quantity!}",
              style:
                  TextStyles.textStyle12.copyWith(fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
            Row(
              children: [
                Text("${productCount.toInt()} X "),
                Hero(
                  tag: "Product${widget.product.id}",
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.w),
                    child: MyCachedNetworkImage(
                      fit: BoxFit.contain,
                      height: 50.h,
                      width: 70.w,
                      url: widget.product.image!,
                      errorIcon: Icon(
                        Icons.image,
                        size: 50.w,
                        color: AppColors.primaryColor,
                      ),
                      loadingWidth: 30.w,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              widget.product.productName!,
                              style: TextStyles.textStyle12
                                  .copyWith(fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          widget.product.description!,
                          style: TextStyles.textStyle10.copyWith(
                              fontWeight: FontWeight.w400, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text:
                                    "${widget.product.pivot!.requiredUnitId! == widget.product.retailUnitId! ? widget.product.retailPrice! : widget.product.wholeSalePrice!}.د",
                                style: TextStyles.textStyle12.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green),
                              )
                            ]),
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
