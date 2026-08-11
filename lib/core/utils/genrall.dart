import 'package:flutter/material.dart';

///the app's single navigator, so layers without a BuildContext (like the dio
///[AuthInterceptor]) can still drive navigation — e.g. bounce the user to the
///login screen the moment the backend rejects their token
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

ValueNotifier<bool> noConnection = ValueNotifier<bool>(false);

ValueNotifier<bool> cartNotEmpty = ValueNotifier<bool>(false);

int role = 0;
