// ignore_for_file: file_names

import 'package:dinar_store/core/utils/app_images.dart';
import 'package:dinar_store/core/utils/text_styles.dart';
import 'package:dinar_store/core/widgets/defult_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefultScaffold(
      canPop: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 50.h,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Image.asset(
                height: 200.w,
                AppImages.dinarImage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 50.h),
            SizedBox(height: 100.h),
            Wrap(
              children: [
                Text(
                  '''تطبيق دينار يعمل كوسيط بين المتسوقين ومتاجر المأكولات والمشروبات، حيث يُسهِّل على المستخدمين تجربة تسوق سلسة ومباشرة دون عناء. يتيح التطبيق للمستخدمين اختيار ما يحتاجونه من مجموعة متنوعة من المأكولات والمشروبات عبر الإنترنت، ويضمن جودة المنتجات للطرفين. باستخدام تطبيق دينار، يمكن للمستخدمين الاستمتاع بتجربة تسوق ممتعة ومضمونة مع التوصيل المباشر إلى باب منزلهم''',
                  style: TextStyles.textStyle16.copyWith(),
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
