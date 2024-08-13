// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:dinar_store/core/animations/right_slide_transition.dart';
import 'package:dinar_store/core/helpers/app_cache/cahch_helper.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/genrall.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/utils/time_date_handler.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/home/presentation/view/bottom_nav_view.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/dividers/ginerall_divider.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/maps/order_location_map.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/order_confirm_action_row.dart';
import 'package:dinar_store/features/home/presentation/view_model/cart_cubit/cubit/cart_cubit.dart';
import 'package:dinar_store/features/home/presentation/view_model/order_cubit/cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderConfirmView extends StatefulWidget {
  const OrderConfirmView({super.key});

  @override
  State<OrderConfirmView> createState() => _OrderConfirmViewState();
}

class _OrderConfirmViewState extends State<OrderConfirmView> {
  @override
  void initState() {
    OrderCubit.initialTime = context.read<OrderCubit>().add24Hours();
    context.read<LocationCubit>().getCurrentLocation(context: context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(onRefresh: () async {
        await context.read<CartCubit>().getAllItems();
        context.read<LocationCubit>().getCurrentLocation(context: context);
        OrderCubit.pickedTime = null;
        OrderCubit.initialTime = DateTime.now();
        OrderCubit.initialTime = context.read<OrderCubit>().add24Hours();

        context.read<OrderCubit>().emit(OrderInitial());
      }, child: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),
                child: Text(
                  'إتمام الشراء',
                  style: TextStyles.textStyle16.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.w,
                  ),
                ),
              ),
              const GeneralDivider(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      OrderConfirmActionRow(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            firstDate: context.read<OrderCubit>().add24Hours(),
                            lastDate: OrderCubit.initialTime!
                                .add(const Duration(days: 9)),
                          );
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: OrderCubit.pickedTime != null
                                ? TimeOfDay(
                                    hour: OrderCubit.pickedTime!.hour,
                                    minute: OrderCubit.pickedTime!.minute,
                                  )
                                : TimeOfDay(
                                    hour: OrderCubit.initialTime!.hour,
                                    minute: OrderCubit.initialTime!.minute,
                                  ),
                          );

                          OrderCubit.pickedTime = DateTime(
                            date!.year,
                            date.month,
                            date.day,
                            time!.hour,
                            time.minute,
                          );
                          context.read<OrderCubit>().emit(OrderInitial());
                        },
                        title: "وقت التوصيل",
                        buttonTitle: 'تغيير',
                        buttonWidth: 70.w,
                        subTitle: OrderCubit.pickedTime != null
                            ? "${MyTimeDate.getLastMessageTime(context: context, time: OrderCubit.pickedTime!.millisecondsSinceEpoch.toString())} , ${MyTimeDate.getMessageTime(context: context, time: OrderCubit.pickedTime!.millisecondsSinceEpoch.toString())}"
                            : "${MyTimeDate.getLastMessageTime(context: context, time: OrderCubit.initialTime!.millisecondsSinceEpoch.toString())} , ${MyTimeDate.getMessageTime(context: context, time: OrderCubit.initialTime!.millisecondsSinceEpoch.toString())}",
                        icon: Icons.calendar_month_rounded,
                      ),
                      const GeneralDivider(),
                      BlocConsumer<LocationCubit, LocationState>(
                        listener: (context, state) {
                          if (state is LocationSuccess) {
                            OrderCubit.markerPosition = LatLng(
                              state.position.latitude,
                              state.position.longitude,
                            );
                            context.read<LocationCubit>().getAddress(
                                  state.position.latitude,
                                  state.position.longitude,
                                );
                          }
                          if (state is AddressSuccess) {
                            OrderCubit.currentAddress = context
                                .read<LocationCubit>()
                                .getAddressString(state.locationData);
                          }
                        },
                        builder: (context, state) {
                          if (state is AddressSuccess) {
                            return OrderConfirmActionRow(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    RightSlideTransition(
                                      page: const OrderLocationMap(),
                                    ));
                              },
                              title: "التوصيل إلى",
                              buttonTitle: 'تغيير',
                              buttonWidth: 100.w,
                              subTitle: OrderCubit.currentAddress,
                              icon: Icons.location_on,
                            );
                          }
                          return const AppLoadingButton();
                        },
                      ),
                      const GeneralDivider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              Text(
                                'إضافة ملاحظات',
                                style: TextStyles.textStyle14
                                    .copyWith(fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          TextField(
                            maxLines: null,
                            textDirection: TextDirection.rtl,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                                hintTextDirection: TextDirection.rtl,
                                hintText: 'أضف ملاحظاتك',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.w),
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.05),
                                    ))),
                          ),
                        ],
                      ),
                      const GeneralDivider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              Text(
                                'إختر طريقة الدفع',
                                style: TextStyles.textStyle14
                                    .copyWith(fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          RadioListTile(
                            value: "الدفع عند الاستلام",
                            groupValue: OrderCubit.payment,
                            onChanged: (newValue) {
                              OrderCubit.payment = newValue!;
                              context.read<OrderCubit>().emit(OrderInitial());
                            },
                            title: Row(
                              children: [
                                const Spacer(),
                                Text(
                                  "الدفع عند الاستلام",
                                  style: TextStyles.textStyle14,
                                ),
                              ],
                            ),
                          ),
                          RadioListTile(
                            value: "عند التوصيل",
                            groupValue: OrderCubit.payment,
                            onChanged: (newValue) {
                              // OrderCubit.payment = newValue!;
                              // context.read<OrderCubit>().emit(OrderInitial());
                            },
                            title: Row(
                              children: [
                                const Spacer(),
                                Text(
                                  "الدفع عن طريق الفيزا",
                                  style: TextStyles.textStyle14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const GeneralDivider(),
                      Row(
                        children: [
                          Text(
                            "${CartCubit.finalPrice}.د",
                            style: TextStyles.textStyle14.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const Spacer(),
                          Text(
                            'السعر النهائى',
                            style: TextStyles.textStyle14.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const GeneralDivider(),
                      BlocConsumer<OrderCubit, OrderState>(
                        listener: (context, state) {
                          if (state is AddOrderFailuer) {
                            context.showMessageSnackBar(
                              message: state.errMessage,
                            );
                          }
                          if (state is AddOrderSuccess) {
                            cartNotEmpty.value = false;
                            CahchHelper.saveData(
                                key: "cartNotEmpty", value: false);
                            context.showMessageSnackBar(
                              message: "تم إرسال الطلب",
                            );
                            Navigator.of(context).popUntil(
                                ModalRoute.withName(BottomNavBarView.id));
                            context.read<CartCubit>().getAllItems();
                            context.read<OrderCubit>().getAllOrders();
                            OrderCubit.markerPosition = null;
                            OrderCubit.pickedTime = null;
                            OrderCubit.currentAddress = "أختر عنوان";
                          }
                        },
                        builder: (context, state) {
                          if (state is AddToOrdersLoading) {
                            return const AppLoadingButton();
                          }
                          return AppDefaultButton(
                            onPressed: () async {
                              OrderCubit.pickedTime = OrderCubit.initialTime;
                              if (OrderCubit.markerPosition != null) {
                                if (OrderCubit.pickedTime != null &&
                                    context
                                        .read<OrderCubit>()
                                        .isTimeGreaterBy24Hour(
                                            OrderCubit.pickedTime!)) {
                                  await context.read<OrderCubit>().storeOrder(
                                        status: 1,
                                        discount: CartCubit.totalDiscount,
                                        tax: 0,
                                        price: CartCubit.totalPrice,
                                        paymentMethod: 'عند الاستلام',
                                      );
                                } else {
                                  context.showMessageSnackBar(
                                    message:
                                        "اختر وقت التوصيل بطريقة صحيحة, يجب أن يكون الوقت على الأقل 24 ساعة من الأن",
                                  );
                                }
                              } else {
                                context.showMessageSnackBar(
                                  message: "اختر الموقع",
                                );
                              }
                            },
                            color: AppColors.primaryColor,
                            title: "إتمام الطلب",
                            textStyle: TextStyles.textStyle16.copyWith(
                              color: AppColors.kWhite,
                              fontSize: 16.w,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}
