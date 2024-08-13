import 'package:dinar_store/core/functions/show_alert_dialog.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/login_view.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/profile_settings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogOutContainer extends StatelessWidget {
  const LogOutContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state is LogOutFailure) {
          context.showMessageSnackBar(
            message: state.errMessage,
          );
        }
        if (state is LogOutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, LogInView.id, (route) => false);
          context.showMessageSnackBar(
            message: "تم الخروج بنجاح",
          );
        }
      },
      builder: (context, state) {
        if (state is LogOutLoading) {
          return SizedBox(
            width: 250.w,
            child: AppLoadingButton(
              width: 10.w,
            ),
          );
        }
        return ProfileSettingsRow(
          title: 'تسجيل الخروج',
          onTap: () {
            showAlertDialog(
              canDismiss: true,
              context,
              child: AlertDialog(
                title: Text(
                  "متأكد أنك تريد تسجيل الخروج ؟",
                  style: TextStyles.textStyle16.copyWith(
                    fontSize: 16.w,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppDefaultButton(
                        width: 100.w,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        title: 'الغاء',
                      ),
                      AppDefaultButton(
                        width: 100.w,
                        onPressed: () {
                          Navigator.pop(context);

                          context.read<LogOutCubit>().logOut();
                        },
                        title: 'نعم',
                      )
                    ],
                  ),
                ],
              ),
            );
          },
          icon: Icons.logout_outlined,
        );
      },
    );
  }
}
