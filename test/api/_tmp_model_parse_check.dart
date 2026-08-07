// THROWAWAY: real-payload parse check. Deleted right after it is run.
//
// run: flutter test --tags live --run-skipped test/api/_tmp_model_parse_check.dart

@Tags(<String>['live'])
library;

import 'package:dinar_store/core/helpers/dio_helper.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/features/home/data/models/ads_model.dart';
import 'package:dinar_store/features/home/data/models/categories_model.dart';
import 'package:dinar_store/features/home/data/models/companies_model.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DioHelper dioHelper;

  setUp(() {
    appDomain = normalizeAppDomain(kDefaultAppDomain);
    dioHelper = DioHelper();
  });

  test('companies payload runs through CompaniesModel.fromJson', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'companies');
    final CompaniesModel model = CompaniesModel.fromJson(data);
    expect(model.companies, isNotNull);
    // ignore: avoid_print
    print('companies parsed: ${model.companies!.length}');
  }, timeout: const Timeout(Duration(seconds: 60)));

  test('categories payload runs through CategoriesModel.fromJson', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'categories');
    final CategoriesModel model = CategoriesModel.fromJson(data);
    expect(model.categories, isNotNull);
    // ignore: avoid_print
    print('categories parsed: ${model.categories!.length}');
  }, timeout: const Timeout(Duration(seconds: 60)));

  test('ads payload runs through AdsModel.fromJson', () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'ads');
    final AdsModel model = AdsModel.fromJson(data);
    expect(model.ads, isNotNull);
    // ignore: avoid_print
    print('ads parsed: ${model.ads!.length}');
  }, timeout: const Timeout(Duration(seconds: 60)));

  test('products payload runs through SubCategoryProductsModel.fromJson',
      () async {
    final Map<String, dynamic> data =
        await dioHelper.getRequest(endPoint: 'products');
    final SubCategoryProductsModel model =
        SubCategoryProductsModel.fromJson(data);
    expect(model.products, isNotNull);
    // ignore: avoid_print
    print('products parsed: ${model.products!.length}');
  }, timeout: const Timeout(Duration(seconds: 60)));
}
