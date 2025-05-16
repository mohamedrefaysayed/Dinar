import 'package:dinar_store/features/splash/presentation/view/widgets/animations/logo_animated_opacity.dart';
import 'package:dinar_store/features/splash/presentation/view/widgets/rich_texts/property_rights_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashViewBodyColumn extends StatelessWidget {
  const SplashViewBodyColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const LogoAnimatedOpacity(),
          const Spacer(),
          const PropertyRightsRichText(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
