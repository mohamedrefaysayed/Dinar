// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:dinar_store/core/utils/app_images.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/widgets/code_builder.dart';
import 'package:dinar_store/features/auth/presentation/view/widgets/phone_builder.dart';
import 'package:dinar_store/features/auth/presentation/view_model/log_in_cubit/log_in_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogInView extends StatelessWidget {
  const LogInView({super.key});

  static const String id = '/LogInView';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
            body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: ListView(
              children: [
                Row(
                  children: [
                    BlocBuilder<LogInCubit, LogInState>(
                      builder: (context, state) {
                        if (state is SendCodeSuccess ||
                            state is VerficationLoading) {
                          return IconButton(
                              onPressed: () {
                                context.read<LogInCubit>().emit(LogInInitial());
                                LogInCubit.phoneNumber = null;
                              },
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                size: 25.w,
                              ));
                        }
                        return SizedBox(
                          height: 45.h,
                        );
                      },
                    ),
                    const Spacer(),
                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.pushNamedAndRemoveUntil(
                    //           context, '/BottomNavBarView', (route) => false);
                    //     },
                    //     child: Text(
                    //       "تخطى",
                    //       style: TextStyles.textStyle18
                    //           .copyWith(color: Colors.grey),
                    //     ))
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                  child: Image.asset(
                    AppImages.loginCart,
                    height: 177.w,
                    width: 177.w,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Hero(
                  tag: 'dinar_logo',
                  child: Center(
                    child: Image.asset(
                      AppImages.dinarImage,
                      height: 70.w,
                      width: 177.w,
                    ),
                  ),
                ),
                SizedBox(
                  height: 70.h,
                ),
                BlocConsumer<LogInCubit, LogInState>(
                  listener: (context, state) {
                    if (state is LogInFailure) {
                      context.showMessageSnackBar(
                        message: state.errMessage,
                      );
                    }
                    if (state is SendCodeSuccess) {
                      context.showMessageSnackBar(
                        message: state.message,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SendCodeSuccess ||
                        state is VerficationLoading) {
                      return const CodeBuilder();
                    } else {
                      return const PhoneBuilder();
                    }
                  },
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
