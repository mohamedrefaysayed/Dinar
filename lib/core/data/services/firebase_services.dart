import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinar_store/core/helpers/app_cache/cahch_helper.dart';
import 'package:dinar_store/core/helpers/notifications.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseServices {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    appDomain = CahchHelper.getData(key: "appDomain") ?? appDomain;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    final appInfo = await FirebaseFirestore.instance
        .collection("Dinar-App")
        .doc("App-Info")
        .get();
    if (kDebugMode) {
      print(appInfo.data()!["domain"]);
    }

    appDomain = appInfo.data()!["domain"] ?? appDomain;

    CahchHelper.saveData(key: "appDomain", value: appDomain);
  }
}
