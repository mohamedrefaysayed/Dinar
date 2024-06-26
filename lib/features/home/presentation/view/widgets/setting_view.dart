import 'package:dinar_store/features/home/presentation/view/widgets/profile_container.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ProfileCubit>().getProfile();
        },
        child: ListView(
          children: [
            SizedBox(
              height: 30.h,
            ),
            const ProfileContainer(),
          ],
        ),
      ),
    );
  }
}
