// Offline tests for parsing the auth payloads of the new backend.
//
// These are the regression tests for the sign in crash
// "type 'String' is not a subtype of type 'int'": /login and /verify on
// https://new.dinnari.com/api/ return `role` as the string "0" and
// `phone_verified` as a bool, while the app read both straight into int
// fields. The same responses also return `user` as a single object where the
// retired backend returned a list.
//
// The payloads below are verbatim responses captured from the live api.
//
// run: flutter test test/api/auth_payload_test.dart

import 'dart:convert';

import 'package:dinar_store/core/utils/json_parse.dart';
import 'package:dinar_store/features/home/data/models/profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

///verbatim /verify response for a user that already has a store
const String kVerifyResponse = '''
{"token":"21|40mYyuWaKS8lpKR1LAHU6uRZrUXom0liacyiefcb9765f578",
"user":{"id":85,"name":"","email":"","created_at":"2025-03-14T11:53:04.000000Z",
"updated_at":"2026-07-31T18:13:18.000000Z","phone":"1090287571",
"country_code":"+20","expire_at":"2026-07-31T18:18:05.000000Z",
"phone_verified":true,"current_device_id":"b8b8b915-85d2-4d39-9e8e-7f940d473f14",
"token_device":"flutter-android","role":"0","status":1,"company_name":"",
"role_id":2,"biller_id":0,"warehouse_id":0,"is_active":true,"is_deleted":false,
"store":{"id":64,"user_id":85,"owner_name":"bzbzn","store_name":"nxsnh",
"district":"shhedh","address":"susnje","phone":"04010186446","lng":32.2647746,
"lat":30.6079394,"status":1,"deleted_at":null,
"created_at":"2025-05-11T11:22:38.000000Z",
"updated_at":"2025-10-18T07:29:02.000000Z"}}}
''';

void main() {
  group('the scalar types the api actually sends', () {
    late Map<String, dynamic> user;

    setUp(() {
      user = (jsonDecode(kVerifyResponse)
          as Map<String, dynamic>)['user'] as Map<String, dynamic>;
    });

    test('role arrives as a string and still reaches the int it is stored in',
        () {
      expect(user['role'], isA<String>());
      expect(asInt(user['role']), 0);
    });

    test('a non zero string role is not silently flattened to zero', () {
      expect(asInt('3'), 3);
    });

    test('phone_verified arrives as a bool and still reads as an int', () {
      expect(user['phone_verified'], isA<bool>());
      expect(asIntOrNull(user['phone_verified']), 1);
    });

    test('a missing role falls back instead of throwing', () {
      expect(asInt(null), 0);
      expect(asInt(<String, dynamic>{}['role']), 0);
    });
  });

  group('ProfileModel on the new backend', () {
    test('parses the /verify payload without throwing', () {
      final ProfileModel profile =
          ProfileModel.fromJson(jsonDecode(kVerifyResponse));

      expect(profile.user, isNotNull);
      expect(profile.user!.length, 1);

      final User parsed = profile.user!.first;
      expect(parsed.id, 85);
      expect(parsed.phone, '1090287571');
      expect(parsed.countryCode, '+20');
      expect(parsed.phoneVerified, 1);
    });

    test('accepts the single user object the api returns', () {
      final ProfileModel profile = ProfileModel.fromJson(
        <String, dynamic>{
          'user': <String, dynamic>{'id': 7, 'name': 'a'},
        },
      );

      expect(profile.user!.single.id, 7);
    });

    test('still accepts the list the retired backend returned', () {
      final ProfileModel profile = ProfileModel.fromJson(
        <String, dynamic>{
          'user': <dynamic>[
            <String, dynamic>{'id': 7, 'name': 'a'},
          ],
        },
      );

      expect(profile.user!.single.id, 7);
    });

    test('a user without a store yields a null store instead of throwing', () {
      final ProfileModel profile = ProfileModel.fromJson(
        <String, dynamic>{
          'user': <String, dynamic>{'id': 7, 'store': null},
        },
      );

      expect(profile.user!.single.store, isNull);
    });

    test('store coordinates survive arriving as strings', () {
      final ProfileModel profile = ProfileModel.fromJson(
        <String, dynamic>{
          'user': <String, dynamic>{
            'id': 7,
            'store': <String, dynamic>{
              'id': 1,
              'lat': '30.6079394',
              'lng': '32.2647746',
              'status': '1',
            },
          },
        },
      );

      final Store store = profile.user!.single.store!;
      expect(store.lat, closeTo(30.6079394, 0.000001));
      expect(store.lng, closeTo(32.2647746, 0.000001));
      expect(store.status, 1);
    });

    test('an integer coordinate is widened instead of throwing', () {
      final ProfileModel profile = ProfileModel.fromJson(
        <String, dynamic>{
          'user': <String, dynamic>{
            'id': 7,
            'store': <String, dynamic>{'id': 1, 'lat': 30, 'lng': 32},
          },
        },
      );

      expect(profile.user!.single.store!.lat, 30.0);
    });
  });

  group('json_parse fallbacks', () {
    test('reads the numeric forms the api mixes for booleans', () {
      expect(asBool(1), isTrue);
      expect(asBool('1'), isTrue);
      expect(asBool('true'), isTrue);
      expect(asBool(0), isFalse);
      expect(asBool('0'), isFalse);
      expect(asBool(null), isFalse);
    });

    test('renders a numeric id as text when a string field receives one', () {
      expect(asStringOrNull(85), '85');
      expect(asStringOrNull(null), isNull);
    });

    test('unparseable text degrades to the fallback', () {
      expect(asInt('not a number', fallback: -1), -1);
      expect(asDouble('', fallback: -1), -1);
    });
  });
}
