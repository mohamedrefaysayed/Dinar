import 'package:dinar_store/core/utils/json_parse.dart';

///search returns three result buckets. the current backend omits a bucket
///entirely when it has no hits, and omits optional scalars ('description',
///'logo', 'discount') from the rows it does send. search_view force unwraps
///all three buckets (`state.searchModel.companies!.isEmpty`) and the grids
///force unwrap the row text (`categories[index].image!`), so the buckets
///default to an empty list and the display text to '' here
class SearchModel {
  List<SearchCompany>? companies;
  List<SearchCategory>? categories;
  List<SearchProduct>? products;

  SearchModel({this.companies, this.categories, this.products});

  SearchModel.fromJson(Map<String, dynamic> json) {
    companies = _parseList(json['companies'], SearchCompany.fromJson);
    categories = _parseList(json['categories'], SearchCategory.fromJson);
    products = _parseList(json['products'], SearchProduct.fromJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

///a bucket may be absent, a list, or - when there is a single hit - a bare
///object. calling forEach on a map passes (key, value) to a one argument
///closure and throws, so every shape is normalised to a list
List<T> _parseList<T>(
  dynamic raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (raw is List) {
    return raw.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }
  if (raw is Map<String, dynamic>) {
    return <T>[fromJson(raw)];
  }
  return <T>[];
}

class SearchCompany {
  int? id;
  String? companyName;
  String? description;
  String? logo;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  SearchCompany(
      {this.id,
      this.companyName,
      this.description,
      this.logo,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ///companies without a logo come back with the field absent, and the row is
  ///handed straight to Companies.fromJson through toJson, where the products
  ///screen force unwraps `company.logo!` and `company.description!`. the text
  ///fields therefore fall back to '' instead of null
  SearchCompany.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    companyName = asString(json['company_name'] ?? json['name']);
    description = asString(json['description']);
    logo = asString(json['logo']);
    status = asInt(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['description'] = description;
    data['logo'] = logo;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SearchCategory {
  int? id;
  String? categoryName;
  String? description;
  String? image;
  int? level;
  int? parentId;
  int? categorySpecificationId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  SearchCategory(
      {this.id,
      this.categoryName,
      this.description,
      this.image,
      this.level,
      this.parentId,
      this.categorySpecificationId,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ///'description' is no longer sent by the backend and the search grid force
  ///unwraps `categories[index].image!` / `.categoryName!`, so the text fields
  ///default to ''. 'parent_id' stays nullable on purpose: the grid branches on
  ///it to tell a root category from a sub category
  SearchCategory.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    categoryName = asString(json['category_name'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image']);
    level = asInt(json['level']);
    parentId = asIntOrNull(json['parent_id']);
    categorySpecificationId = asInt(json['category_specification_id']);
    status = asInt(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['description'] = description;
    data['image'] = image;
    data['level'] = level;
    data['parent_id'] = parentId;
    data['category_specification_id'] = categorySpecificationId;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SearchProduct {
  int? id;
  String? productName;
  String? description;
  String? image;
  int? wholeSalePrice;
  int? retailPrice;
  int? vipPrice;
  int? categoryId;
  int? companyId;
  int? unitGroupId;
  int? wholeUnitId;
  int? retailUnitId;
  int? vipUnitId;
  int? discount;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? minWholeQuantity;
  int? minRetailQuantity;
  int? minVipQuantity;
  int? maxWholeQuantity;
  int? maxRetailQuantity;

  SearchProduct(
      {this.id,
      this.productName,
      this.description,
      this.image,
      this.wholeSalePrice,
      this.retailPrice,
      this.vipPrice,
      this.categoryId,
      this.companyId,
      this.unitGroupId,
      this.wholeUnitId,
      this.retailUnitId,
      this.vipUnitId,
      this.discount,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.minWholeQuantity,
      this.minRetailQuantity,
      this.minVipQuantity,
      this.maxWholeQuantity,
      this.maxRetailQuantity});

  ///the search row is converted into a Products through toJson before the
  ///product screen opens, and that screen force unwraps the prices, the unit
  ///ids and the min/max quantities. the backend now sends prices as decimal
  ///strings ("0.000000") and drops 'discount' completely, so every number is
  ///parsed leniently and falls back to 0 rather than throwing either
  ///"Null check operator used on a null value" or
  ///"type 'String' is not a subtype of type 'int'"
  SearchProduct.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    productName = asString(json['product_name'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image']);
    wholeSalePrice = asInt(json['whole_sale_price']);
    retailPrice = asInt(json['retail_price']);
    vipPrice = asInt(json['vip_price']);
    categoryId = asInt(json['category_id']);
    companyId = asInt(json['company_id']);
    unitGroupId = asInt(json['unit_group_id']);
    wholeUnitId = asInt(json['whole_unit_id']);
    retailUnitId = asInt(json['retail_unit_id']);
    vipUnitId = asInt(json['vip_unit_id']);
    discount = asInt(json['discount']);
    status = asInt(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
    minWholeQuantity = asInt(json['min_whole_quantity']);
    minRetailQuantity = asInt(json['min_retail_quantity']);
    minVipQuantity = asInt(json['min_vip_quantity']);
    maxWholeQuantity = asInt(json['max_whole_quantity']);
    maxRetailQuantity = asInt(json['max_retail_quantity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['description'] = description;
    data['image'] = image;
    data['whole_sale_price'] = wholeSalePrice;
    data['retail_price'] = retailPrice;
    data['vip_price'] = vipPrice;
    data['category_id'] = categoryId;
    data['company_id'] = companyId;
    data['unit_group_id'] = unitGroupId;
    data['whole_unit_id'] = wholeUnitId;
    data['retail_unit_id'] = retailUnitId;
    data['vip_unit_id'] = vipUnitId;
    data['discount'] = discount;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['min_whole_quantity'] = minWholeQuantity;
    data['min_retail_quantity'] = minRetailQuantity;
    data['min_vip_quantity'] = minVipQuantity;
    data['max_whole_quantity'] = maxWholeQuantity;
    data['max_retail_quantity'] = maxRetailQuantity;
    return data;
  }
}
