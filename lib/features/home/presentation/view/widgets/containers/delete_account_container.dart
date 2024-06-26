import 'package:dinar_store/core/functions/show_alert_dialog.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/login_view.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:dinar_store/features/home/presentation/view/widgets/rows/profile_settings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAccountContainer extends StatelessWidget {
  const DeleteAccountContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogOutCubit, LogOutState>(
      listener: (context, state) {
        if (state is DeleteAccountFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(messageSnackBar(message: state.errMessage));
        }
        if (state is DeleteAccountSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, LogInView.id, (route) => false);
          ScaffoldMessenger.of(context)
              .showSnackBar(messageSnackBar(message: "تم حذف الحساب بنجاح"));
        }
      },
      builder: (context, state) {
        if (state is DeleteAccountLoading) {
          return SizedBox(
            width: 250.w,
            child: AppLoadingButton(
              width: 10.w,
            ),
          );
        }
        return ProfileSettingsRow(
          title: 'حذف الحساب',
          iconColor: AppColors.kRed,
          onTap: () {
            showAlertDialog(
              context,
              child: AlertDialog(
                title: Center(
                  child: Text(
                    'هل تريد حذف الحساب؟',
                    style: TextStyles.textStyle18,
                  ),
                ),
                actions: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'إلغاء',
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.kASDCPrimaryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<LogOutCubit>(context).deleteAccount();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'حذف',
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.kASDCPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          icon: Icons.delete_forever,
        );
      },
    );
  }
}
