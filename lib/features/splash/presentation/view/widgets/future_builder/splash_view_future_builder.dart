// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:dinar_store/core/helpers/internet_connection/InternetConnection.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/features/splash/presentation/view/widgets/splash_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../view_model/manage_navigation_cubit/manage_navigation_cubit.dart';

class SplashViewFutureBuilder extends StatelessWidget {
  const SplashViewFutureBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3), () async {
        BlocProvider.of<ManageNavigationCubit>(context).getAppData(context);
        context.checkInternet();
      }),
      builder: (context, snapShot) => const Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SplashViewBody(),
      ),
    );
  }
}
