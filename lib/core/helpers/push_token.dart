import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

///single source of truth for the push token the api is given.
///
///the backend field is 'fcm_token' and it pushes through firebase, so what it
///needs is the fcm *registration* token from [FirebaseMessaging.getToken].
///the app used to send [FirebaseMessaging.getAPNSToken] on ios, which is the
///raw apns device token: a different value that firebase cannot address, so
///every ios push was rejected.
///
///getToken() cannot simply be called on ios either. the plugin refuses it
///until apns has handed the device token to firebase and throws
///`[firebase_messaging/apns-token-not-set]` before then, so this waits for the
///apns token first, bounded, and swallows the failure.
///
///nothing here may block or fail sign in: every method returns null rather
///than throwing, and [get] gives up quickly.
abstract final class PushToken {
  static String? _cached;

  ///the token already in hand, if any
  static String? get cached => _cached;

  static Future<String?>? _inFlight;
  static StreamSubscription<String>? _refreshSub;

  ///start acquiring in the background. called once at startup so the token is
  ///usually cached by the time the user finishes the verification screen
  static void warmUp({Duration budget = const Duration(seconds: 20)}) {
    _inFlight ??= _acquire(budget);
  }

  ///the value to put in the /verify body. returns null, never throws, when
  ///push is denied, unconfigured, or simply not ready yet
  static Future<String?> get({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (_cached != null) return _cached;
    warmUp();
    final String? token = await _inFlight!.timeout(
      timeout,
      onTimeout: () => null,
    );
    return token ?? _cached;
  }

  ///keep the cache current when firebase rotates the token.
  ///
  ///the backend accepts a token only in the POST /verify body, there is no
  ///endpoint to update one for a signed in user, so [upload] is optional and
  ///today there is nothing to pass. once such a route exists, hand it in here
  static void listenForRefresh([
    Future<void> Function(String token)? upload,
  ]) {
    _refreshSub?.cancel();
    _refreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(
      (String token) async {
        _cached = token;
        if (upload == null) return;
        try {
          await upload(token);
        } catch (error) {
          debugPrint('PushToken: could not upload the refreshed token: $error');
        }
      },
      onError: (Object error) {
        debugPrint('PushToken: onTokenRefresh failed: $error');
      },
    );
  }

  @visibleForTesting
  static void reset() {
    _cached = null;
    _inFlight = null;
    _refreshSub?.cancel();
    _refreshSub = null;
  }

  static Future<String?> _acquire(Duration budget) async {
    final DateTime deadline = DateTime.now().add(budget);

    ///ios only mints an apns token once the app has asked. this is idempotent,
    ///and a denial is not fatal: ios still issues the device token, so the fcm
    ///token stays valid and starts delivering if notifications are enabled later
    try {
      await FirebaseMessaging.instance.requestPermission();
    } catch (error) {
      debugPrint('PushToken: requestPermission failed: $error');
    }

    if (Platform.isIOS || Platform.isMacOS) {
      final bool ready = await _awaitApnsToken(deadline);
      if (!ready) {
        ///without it getToken() only throws. the most common cause is a
        ///missing Push Notifications capability on the Runner target
        debugPrint(
          'PushToken: no apns token before the deadline, skipping getToken()',
        );
        return null;
      }
    }

    try {
      _cached = await FirebaseMessaging.instance.getToken();
    } catch (error) {
      debugPrint('PushToken: getToken failed: $error');
      _cached = null;
    }
    return _cached;
  }

  ///poll until apns delivers, since registration completes asynchronously
  ///well after launch
  static Future<bool> _awaitApnsToken(DateTime deadline) async {
    Duration wait = const Duration(milliseconds: 250);
    while (true) {
      try {
        final String? apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns != null && apns.isNotEmpty) return true;
      } catch (error) {
        debugPrint('PushToken: getAPNSToken failed: $error');
      }

      if (!DateTime.now().add(wait).isBefore(deadline)) return false;
      await Future<void>.delayed(wait);

      ///back off up to two seconds so a denied or unconfigured device is not
      ///polled tightly for the whole budget
      if (wait < const Duration(seconds: 2)) wait *= 2;
    }
  }
}
