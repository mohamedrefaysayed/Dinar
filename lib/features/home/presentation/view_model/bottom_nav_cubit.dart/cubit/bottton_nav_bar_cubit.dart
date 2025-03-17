import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'bottton_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarInitial());

  static int index = 3;
  static int dIndex = 1;

  static PageController controller = PageController(
    initialPage: 4,
  );
  static List<TabItem> items = [
    const TabItem(
      icon: Icons.person_4_outlined,
      // title: 'بياناتي',
    ),
    const TabItem(
      icon: Icons.delivery_dining_outlined,
      // title: 'طلباتي',
    ),
    const TabItem(
      icon: Icons.shopping_bag_outlined,
      // title: 'العربة',
    ),
    const TabItem(
      icon: Icons.store,
      // title: 'الرئيسية',
    ),
  ];

  static List<TabItem> dItems = [
    const TabItem(
      icon: Icons.person_2_rounded,
      // title: 'البروفايل',
    ),
    const TabItem(
      icon: Icons.receipt_long_rounded,
      // title: 'الطلبات',
    ),
  ];
}
