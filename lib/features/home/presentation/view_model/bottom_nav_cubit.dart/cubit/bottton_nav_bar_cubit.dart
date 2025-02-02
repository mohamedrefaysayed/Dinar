import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'bottton_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarInitial());

  static int index = 4;
  static int dIndex = 1;

  static PageController controller = PageController(
    initialPage: 5,
  );
  static List<TabItem> items = [
    const TabItem(
      icon: Icons.person_2_rounded,
      title: 'البروفايل',
    ),
    const TabItem(
      icon: Icons.receipt_long_rounded,
      title: 'الطلبات',
    ),
    const TabItem(
      icon: Icons.shopping_cart_rounded,
      title: 'العربة',
    ),
    const TabItem(
      icon: Icons.category_rounded,
      title: 'الأقسام',
    ),
    const TabItem(
      icon: Icons.home_rounded,
      title: 'الرئيسية',
    ),
  ];

  static List<TabItem> dItems = [
    const TabItem(
      icon: Icons.person_2_rounded,
      title: 'البروفايل',
    ),
    const TabItem(
      icon: Icons.receipt_long_rounded,
      title: 'الطلبات',
    ),
  ];
}
