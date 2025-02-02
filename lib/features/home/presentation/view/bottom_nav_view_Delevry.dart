// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/helpers/internet_connection/InternetConnection.dart';
import 'package:dinar_store/core/helpers/notifications.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/message_snack_bar.dart';
import 'package:dinar_store/features/auth/presentation/view/login_view.dart';
import 'package:dinar_store/features/home/presentation/view/delevry_orders.dart';
import 'package:dinar_store/features/home/presentation/view/profile_view_Delevry.dart';
import 'package:dinar_store/features/home/presentation/view_model/bottom_nav_cubit.dart/cubit/bottton_nav_bar_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBarViewDelevry extends StatefulWidget {
  const BottomNavBarViewDelevry({Key? key}) : super(key: key);

  static const id = '/BottomNavBarViewDelevry';

  @override
  State<BottomNavBarViewDelevry> createState() =>
      _BottomNavBarViewDelevryState();
}

class _BottomNavBarViewDelevryState extends State<BottomNavBarViewDelevry>
    with WidgetsBindingObserver {
  late Timer internetTimer;

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        Notifications.showNotification(
          id: DateTime.now().millisecondsSinceEpoch % 0x7FFFFFFF,
          title: message.notification!.title!,
          body: message.notification!.body!,
          localNotifications: FlutterLocalNotificationsPlugin(),
        );
      },
    );
    WidgetsBinding.instance.addObserver(this);
    internetTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      context.checkInternet();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: ScaffoldMessenger(
            child: Scaffold(
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: BottomNavBarCubit.controller,
                children: const [
                  ProfileViewDelevry(),
                  DelevryOrders(),
                ],
              ),
              bottomNavigationBar: BottomBarDefault(
                iconSize: 25.w,
                items: BottomNavBarCubit.dItems,
                backgroundColor: Colors.white,
                color: Colors.grey,
                colorSelected: AppColors.primaryColor,
                indexSelected: BottomNavBarCubit.dIndex,
                titleStyle: TextStyles.textStyle12
                    .copyWith(fontWeight: FontWeight.w700),
                onTap: (int tappedIndex) {
                  if (AppCubit.token == null &&
                      (tappedIndex == 0 ||
                          tappedIndex == 1 ||
                          tappedIndex == 2)) {
                    context.showMessageSnackBar(
                      message: "يجب تسجيل الدخول أولا",
                    );
                    Navigator.pushNamedAndRemoveUntil(
                        context, LogInView.id, (route) => false);
                  } else {
                    BottomNavBarCubit.dIndex = tappedIndex;
                    BottomNavBarCubit.controller.jumpToPage(tappedIndex);
                    context
                        .read<BottomNavBarCubit>()
                        .emit(BottomNavBarUpdate());
                  }
                },
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8.w,
                    spreadRadius: 0.5.w,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
