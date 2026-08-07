import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinar_store/core/helpers/app_cache/cahch_helper.dart';
import 'package:dinar_store/core/helpers/notifications.dart';
import 'package:dinar_store/core/helpers/push_token.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/core/utils/genrall.dart';
import 'package:dinar_store/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseServices {
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    appDomain = normalizeAppDomain(CahchHelper.getData(key: kAppDomainCacheKey));

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    ///the push token is posted with POST /verify, which happens before the app
    ///ever reaches a screen that asks for notification permission, and on ios
    ///it is only mintable once apns has registered. start it here so it is
    ///cached by the time the user finishes the verification code
    PushToken.warmUp();

    ///firebase rotates the token; the api has no route to update one outside
    ////verify, so for now this only keeps the cache fresh for the next sign in
    PushToken.listenForRefresh();

    ///a missing doc, a missing 'domain' field or an unreachable firestore
    ///must not take the whole app down, the cached/default domain still works
    try {
      final appInfo = await FirebaseFirestore.instance
          .collection("Dinar-App")
          .doc("App-Info")
          .get();
      if (kDebugMode) {
        print(appInfo.data()?["domain"]);
      }

      appDomain = normalizeAppDomain(
        appInfo.data()?["domain"],
        fallback: appDomain,
      );

      CahchHelper.saveData(key: kAppDomainCacheKey, value: appDomain);
    } catch (error) {
      if (kDebugMode) {
        print('could not fetch the app domain from firestore: $error');
      }
    }

    cartNotEmpty.value = CahchHelper.getData(key: "cartNotEmpty") ?? false;
  }
}
