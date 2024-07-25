import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/app_images.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/widgets/text_field_data_builder.dart';
import 'package:dinar_store/features/auth/presentation/view_model/location_cubit/cubit/location_cubit.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_in_cubit/log_in_cubit.dart';
import 'package:dinar_store/features/auth/presentation/view_model/store_data_cubit/store_data_cubit.dart';
import 'package:dinar_store/features/home/presentation/view/bottom_nav_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginData extends StatelessWidget {
  const LoginData({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          LogInCubit.phoneNumber = null;
          LogInCubit.code = null;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Form(
              key: StoreDataCubit.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: ListView(
                children: [
                  SizedBox(
                    height: 70.h,
                  ),
                  Hero(
                    tag: 'dinar_logo',
                    child: Center(
                      child: Image.asset(
                        AppImages.dinarLogo,
                        height: 40.w,
                        width: 177.w,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  TextFieldDataBulder(
                    controller: StoreDataCubit.nameController,
                    title: 'الاسم الثلاثي لصاحب العمل',
                    onChanged: (value) {},
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'أدخل الأسم';
                      }
                      return null;
                    },
                  ),
                  TextFieldDataBulder(
                    controller: StoreDataCubit.marketNameController,
                    title: 'أسم الماركت ',
                    onChanged: (value) {},
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'أدخل أسم الماركت ';
                      }
                      return null;
                    },
                  ),
                  TextFieldDataBulder(
                    controller: StoreDataCubit.govController,
                    title: 'المحافظة',
                    onChanged: (value) {},
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'أدخل المحافظة';
                      }
                      return null;
                    },
                  ),
                  TextFieldDataBulder(
                    controller: StoreDataCubit.addressController,
                    title: 'العنوان الكامل مع اقرب نقطة دالة',
                    onChanged: (value) {},
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'أدخل العنوان';
                      }
                      return null;
                    },
                  ),
                  TextFieldDataBulder(
                    keyType: TextInputType.number,
                    controller: StoreDataCubit.marketPhoneController,
                    title: 'رقم هاتف الماركت(العمل)',
                    onChanged: (value) {},
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'أدخل رقم الهاتف';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[0-9]"),
                      )
                    ],
                  ),
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, state) {
                      if (state is LocationLoading) {
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.w, vertical: 10.h),
                            child: const AppLoadingButton());
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 10.h),
                        child: AppDefaultButton(
                          icon: (state is LocationSuccess)
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 25.w,
                                )
                              : Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 25.w,
                                ),
                          textStyle: TextStyles.textStyle16.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.w,
                          ),
                          onPressed: () async {
                            await context
                                .read<LocationCubit>()
                                .getCurrentLocation(context: context);
                          },
                          title: 'تحديد موقعي',
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: BlocConsumer<StoreDataCubit, StoreDataState>(
                      listener: (context, state) {
                        if (state is StoreDataSuccess) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, BottomNavBarView.id, (route) => false);
                          ScaffoldMessenger.of(context).showSnackBar(
                              messageSnackBar(
                                  message: "تم الحفظ بنجاح !",
                                  isBottomNavBar: true));
                        }
                        if (state is StoreDataFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              messageSnackBar(message: state.errMessage));
                        }
                      },
                      builder: (context, state) {
                        if (state is StoreDataLoading) {
                          return AppLoadingButton(
                            width: 10.w,
                          );
                        }
                        return AppDefaultButton(
                          textStyle: TextStyles.textStyle16.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.w,
                          ),
                          onPressed: () {
                            if (LocationCubit.currentPosition != null) {
                              if (StoreDataCubit.formKey.currentState!
                                  .validate()) {
                                context.read<StoreDataCubit>().storeData();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  messageSnackBar(message: "حدد الموقع"));
                            }
                          },
                          title: 'حفظ',
                          color: AppColors.primaryColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
