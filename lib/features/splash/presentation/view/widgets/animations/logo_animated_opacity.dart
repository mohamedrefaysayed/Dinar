import 'package:dinar_store/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoAnimatedOpacity extends StatefulWidget {
  const LogoAnimatedOpacity({super.key});

  @override
  State<LogoAnimatedOpacity> createState() => _LogoAnimatedOpacityState();
}

class _LogoAnimatedOpacityState extends State<LogoAnimatedOpacity> {
  final ValueNotifier<double> _opacity = ValueNotifier<double>(0);

  @override
  void dispose() {
    _opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1), () {
        _opacity.value = 1;
      }),
      builder: (context, snapshot) => ValueListenableBuilder(
        valueListenable: _opacity,
        builder: (context, opacity, child) => AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 1500),
          child: Image.asset(
            color: Colors.white,
            AppImages.dinarLogo,
            height: 190.w,
            width: 190.w,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
