// ignore_for_file: use_build_context_synchronously

import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/widgets/phone_text_field_builder.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_in_cubit/log_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneBuilder extends StatelessWidget {
  const PhoneBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          " يجب ان يكون رقم الهاتف مسجل بالواتساب",
          style: TextStyles.textStyle16.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 16.w,
            overflow: TextOverflow.visible,
          ),
        ),
        SizedBox(
          height: 75.h,
        ),
        PhoneTextFieldBuilder(
          onChanged: (PhoneNumber? newValue) {
            LogInCubit.phoneNumber = newValue;
          },
        ),
        SizedBox(
          height: 70.h,
        ),
        BlocBuilder<LogInCubit, LogInState>(
          builder: (context, state) {
            if (state is SendCodeLoading || state is VerficationLoading) {
              return AppLoadingButton(
                height: 50.h,
                width: double.infinity,
              );
            }
            return AppDefaultButton(
              height: 50.h,
              onPressed: () async {
                HapticFeedback.lightImpact();
                if (LogInCubit.phoneNumber != null) {
                  try {
                    LogInCubit.phoneNumber!.isValidNumber();
                    await BlocProvider.of<LogInCubit>(context).register();
                  } catch (e) {
                    context.showMessageSnackBar(
                      message: "أدخل رقم صحيح",
                    );
                  }
                } else {
                  context.showMessageSnackBar(
                    message: "أدخل رقم الهاتف",
                  );
                }
              },
              title: 'أرسال',
              color: AppColors.primaryColor,
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
