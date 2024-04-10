// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:dinar_store/core/animations/left_slide_transition.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/login_data.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_in_cubit/log_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class CodeBuilder extends StatelessWidget {
  const CodeBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "ستصلك رسالة الى الواتساب فيها رمز التأكيد",
          style: TextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 16.w,
            overflow: TextOverflow.visible,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          LogInCubit.fakeCode ?? "no",
          style: TextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 16.w,
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        Center(
          child: VerificationCode(
              underlineWidth: 2,
              length: 6,
              underlineColor: AppColors.kASDCPrimaryColor,
              textStyle: TextStyle(
                  color: AppColors.kASDCPrimaryColor, fontSize: 20.sp),
              underlineUnfocusedColor:
                  AppColors.kASDCPrimaryColor.withOpacity(0.5),
              fillColor: Colors.white.withOpacity(.05),
              itemSize: 45.w,
              fullBorder: true,
              onCompleted: (code) {
                LogInCubit.code = code;
              },
              onEditing: (code) {}),
        ),
        SizedBox(
          height: 110.h,
        ),
        BlocConsumer<LogInCubit, LogInState>(
          listener: (context, state) {
            if (state is VerficationSuccess) {
              Navigator.push(
                  context, LeftSlideTransition(page: const LoginData()));
            }
          },
          builder: (context, state) {
            if (state is VerficationLoading) {
              return AppLoadingButton(
                height: 50.h,
                width: double.infinity,
              );
            }
            return AppDefaultButton(
              height: 50.h,
              onPressed: () async {
                HapticFeedback.lightImpact();

                if (LogInCubit.code != null) {
                  if (LogInCubit.code!.length == 6) {
                    context.read<LogInCubit>().sendVerficationCode();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        messageSnackBar(message: "أدخل كود صحيح"));
                  }
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(messageSnackBar(message: "أدخل الكود"));
                }
              },
              title: 'أرسال',
              color: AppColors.kASDCPrimaryColor,
              borderRadius: BorderRadius.circular(15.w),
              width: double.infinity,
              textStyle: TextStyles.textStyle16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.w,
              ),
            );
          },
        ),
      ],
    );
  }
}
