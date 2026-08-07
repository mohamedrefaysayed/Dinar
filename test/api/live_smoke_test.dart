// Live smoke test against https://new.dinnari.com/api/.
//
// Unlike the rest of test/api/ this one really hits the network, so it is
// tagged and excluded from the default run. It drives the app's own
// DioHelper and models, which is what makes it worth having: the empty home
// screen was caused by DioHelper sending a body on every GET, something a
// curl of the same url could never reproduce.
//
// run: flutter test test/api/live_smoke_test.dart --tags live

@Tags(<String>['live'])
library;

import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/features/home/data/models/ads_model.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/data/models/companies_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DioHelper dioHelper;

  setUp(() {
    appDomain = normalizeAppDomain(kDefaultAppDomain);
    dioHelper = DioHelper();
  });

  test('companies load and parse', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'companies');
    final CompaniesModel model = CompaniesModel.fromJson(data);

    expect(model.companies, isNotEmpty);
    expect(model.companies!.first.companyName, isNotEmpty);
  }, timeout: const Timeout(Duration(seconds: 60)));

  test('categories load and parse', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'categories');
    final CategoriesModel model = CategoriesModel.fromJson(data);

    expect(model.categories, isNotEmpty);
  }, timeout: const Timeout(Duration(seconds: 60)));

  test('ads load and parse', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'ads');
    final AdsModel model = AdsModel.fromJson(data);

    expect(model.ads, isNotEmpty);
  }, timeout: const Timeout(Duration(seconds: 60)));

  test('products load', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'products');

    expect(data['products'], isNotNull);
  }, timeout: const Timeout(Duration(seconds: 60)));

  ///the anonymous token the public cubits pass must not change the outcome
  test('an empty token still reads the public endpoints', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'companies', token: '');

    expect(CompaniesModel.fromJson(data).companies, isNotEmpty);
  }, timeout: const Timeout(Duration(seconds: 60)));
}
