import 'dart:ui';

import 'package:flutter/foundation.dart';

///whether the in-app network inspector is wired up. always on in debug builds;
///in a release build only when compiled with --dart-define=INSPECTOR=true, so a
///tester can be handed a signed, performant build that still captures requests.
///normal store releases omit the flag and ship with no inspector
const bool kInspectorEnabled =
    kDebugMode || bool.fromEnvironment('INSPECTOR');

const String kAppearanceKey = 'appearanceKey';

const String kUserModelKey = 'userModelKey';

const String kAppInfoKey = 'appInfo';

const String kAppInfoModelBox = 'appInfoModelBox';

const String kAppName = 'ASDC QIS';

const String kClientKey = 'client';

const String kClientModelBox = 'clientModelBox';

const String kUserModelBox = 'userModelBox';

late bool kIsTablet;

const String kSecureStorageKey = 'secureStorageKey';

const String kThemeBox = 'themeBox';

final List<Color> comapniesBgColor = [
  const Color(0xffF0FCFF),
  const Color(0xffFCE3E2),
  const Color(0xffFEF1DB),
  const Color(0xffF5FCE9),
];

///the api base url shipped with the build, used until (and if)
///a domain is fetched from firestore in [FirebaseServices.init]
const String kDefaultAppDomain = "https://new.dinnari.com/api/";

///the api base url every request is sent to.
///always assign it through [normalizeAppDomain]
String appDomain = kDefaultAppDomain;

///versioned so installs that cached the retired domain fall back to
///[kDefaultAppDomain] instead of reusing it
const String kAppDomainCacheKey = 'appDomain_v2';

///dio joins the base url and the endpoint by plain string concatenation
///(`baseUrl + endPoint`), so a base url without a trailing slash turns
///'https://new.dinnari.com/api' + 'register' into
///'https://new.dinnari.com/apiregister' and every request returns 404.
///this also protects against a null/blank domain coming from firestore or the cache
String normalizeAppDomain(dynamic domain, {String fallback = kDefaultAppDomain}) {
  final String trimmed = (domain is String) ? domain.trim() : '';
  if (trimmed.isEmpty) return fallback;
  return trimmed.endsWith('/') ? trimmed : '$trimmed/';
}

///the url the uploaded images of the current [appDomain] are served from
///
///the retired backend served them from public/storage/ and returned bare
///paths ('images/x.jpg'), while the current one serves them from the site root
///and returns the prefix itself ('/storage/images/x.jpg' for categories,
///companies and products, 'images/x.jpg' for ads)
String get appAssetsDomain {
  const String legacyApiSegment = 'index.php/api/';
  if (appDomain.endsWith(legacyApiSegment)) {
    final String root =
        appDomain.substring(0, appDomain.length - legacyApiSegment.length);
    return '${root}storage/';
  }

  const String apiSegment = 'api/';
  if (appDomain.endsWith(apiSegment)) {
    return appDomain.substring(0, appDomain.length - apiSegment.length);
  }

  return appDomain;
}

///build the full url of an image path returned by the api
String buildImageUrl(String? path) {
  final String trimmed = path?.trim() ?? '';
  if (trimmed.isEmpty) return '';
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }

  String relative = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;

  ///the backend double prefixes company logos
  ///('/storage/images/images/x.jpg'), which 404s, while the file itself sits
  ///at '/storage/images/x.jpg'. drop the repeat until the api stops sending it
  relative = relative.replaceFirst('images/images/', 'images/');

  final String root = appAssetsDomain;

  ///never repeat a prefix the api already included
  const String storageSegment = 'storage/';
  if (root.endsWith(storageSegment) && relative.startsWith(storageSegment)) {
    return '$root${relative.substring(storageSegment.length)}';
  }

  return '$root$relative';
}
