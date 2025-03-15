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
        child: ListView(
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
                  '''تطبيق دينار لا يبيع المنتجات فقط للعملاء
نحن في دينار نبيع خدماتنا لأصحاب الماركتات
لأن المنتجات متوفرة في كل مكان لكن خدماتنا لا تتوفر عند الجميع .
فنحن " عائلة دينار " على وعي تام بأن أصحاب الماركتات وقتهم ثمين
ونحن أنشئنا دينار لتسهيل عمل صاحب الماركت ويكون العبئ الاكبر علينا
فالتسوق والتبضع يحتاج إلى يوم كامل وأحيانا إلى يومين او أكثر.
تستيقض صباحاً من النوم وانت متعب وتسارع الوقت من أجل التبضع باكراً
ناهيك عن الأنتظار في محال التبضع لأستكمال الفاتورة وضياع الوقت الثمين
وزحام الطرقات وأحتمال أن يكون ماركتك مغلق من اجل التسوق
وكل هذهِ المشاكل اللتي تهدر وقتك
نحن سنتكفل بها ونوفر لك الوقت الكافي للإستمتاع في حياتك
وقضاء وقت اطول مع اصدقائك وعائلتك وأحبائك .
نحن مهتمون براحتك أكثر من تسويق بضاعتنا لك .
فقط بضع دقائق من وقتك في أي مكان تكون فيه.. مع العائلة او اصدقائك
او في سفرك او انشغالك في بيتك او في ماركتك
تتصفح في التطبيق وتحجز بضاعتك اون لاين وتغلق جوالك وتعود لممارسة حياتك
وفي اليوم التالي بضاعتك في ماركتك .

تتمنى لك عائلة دينار قضاء وقت جميل مع عائلتك واصدقائك ومن تحب..
محبتنا لكم .''',
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
