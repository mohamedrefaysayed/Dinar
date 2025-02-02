import 'package:dinar_store/features/auth/presentation/view/login_view.dart';
import 'package:dinar_store/features/home/presentation/view/bottom_nav_view.dart';
import 'package:dinar_store/features/home/presentation/view/bottom_nav_view_Delevry.dart';
import 'package:dinar_store/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

abstract class AppRoutes {
  static Map<String, Widget Function(BuildContext context)> routes = {
    '/': (context) => const SplashView(),
    LogInView.id: (context) => const LogInView(),
    BottomNavBarView.id: (context) => const BottomNavBarView(),
    BottomNavBarViewDelevry.id: (context) => const BottomNavBarViewDelevry(),
  };
}
