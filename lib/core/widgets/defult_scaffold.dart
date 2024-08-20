import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefultScaffold extends StatelessWidget {
  const DefultScaffold({
    super.key,
    required this.body,
    this.floatingActionButton, this.canPop,
  });
  final Widget body;
  final Widget? floatingActionButton;
  final bool? canPop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          body,
          if (canPop != null && canPop!)
            SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.primaryColor,
                  size: 30.sp,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
