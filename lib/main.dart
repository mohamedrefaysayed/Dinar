import 'package:dinar_store/core/data/services/firebase_services.dart';
import 'package:dinar_store/core/helpers/app_cache/cahch_helper.dart';
import 'package:dinar_store/core/helpers/notifications.dart';
import 'package:dinar_store/core/main_muli_bloc_provider.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/app_routes.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CahchHelper.init();
  await FirebaseServices.init();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Notifications.initilization(FlutterLocalNotificationsPlugin());

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(), // Wrap your app
    // ),
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //check if device is mobile or tablet
    kIsTablet = MediaQuery.sizeOf(context).width >= 600;
    //set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.kTransparent,
      ),
    );
    return MainMultiBlocProvider(
      child: ScreenUtilInit(
        designSize: const Size(375, 811),
        minTextAdapt: true,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dinar',
            theme: ThemeData(
              fontFamily: 'SegoeUI',
              scaffoldBackgroundColor: Colors.white,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: AppColors.kASDCPrimaryColor),
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: AppRoutes.routes,
          ),
        ),
      ),
    );
  }
}
