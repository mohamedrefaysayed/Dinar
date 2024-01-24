import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/app_default_button.dart';
import 'package:dinar_store/core/widgets/app_loading_button.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/login_view.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogOutContainer extends StatelessWidget {
  const LogOutContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocConsumer<LogOutCubit, LogOutState>(
        listener: (context, state) {
          if (state is LogOutFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(messageSnackBar(message: state.errMessage));
          }
          if (state is LogOutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, LogInView.id, (route) => false);
            ScaffoldMessenger.of(context)
                .showSnackBar(messageSnackBar(message: "تم الخروج بنجاح"));
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
          return AppDefaultButton(
            width: 200.w,
            color: AppColors.kASDCPrimaryColor,
            textStyle: TextStyles.textStyle16.copyWith(
              color: AppColors.kWhite,
            ),
            title: 'خروج',
            onPressed: () {
              context.read<LogOutCubit>().logOut();
            },
          );
        },
      ),
    );
  }
}
