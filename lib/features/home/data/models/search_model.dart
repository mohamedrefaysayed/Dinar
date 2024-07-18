class SearchModel {
  List<SearchCompany>? companies;
  List<SearchCategory>? categories;
  List<SearchProduct>? products;

  SearchModel({this.companies, this.categories, this.products});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['companies'] != null) {
      companies = <SearchCompany>[];
      json['companies'].forEach((v) {
        companies!.add(SearchCompany.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <SearchCategory>[];
      json['categories'].forEach((v) {
        categories!.add(SearchCategory.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <SearchProduct>[];
      json['products'].forEach((v) {
        products!.add(SearchProduct.fromJson(v));
      });
    }
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

  SearchCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    description = json['description'];
    logo = json['logo'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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

  SearchCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    description = json['description'];
    image = json['image'];
    level = json['level'];
    parentId = json['parent_id'];
    categorySpecificationId = json['category_specification_id'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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

  SearchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    description = json['description'];
    image = json['image'];
    wholeSalePrice = json['whole_sale_price'];
    retailPrice = json['retail_price'];
    vipPrice = json['vip_price'];
    categoryId = json['category_id'];
    companyId = json['company_id'];
    unitGroupId = json['unit_group_id'];
    wholeUnitId = json['whole_unit_id'];
    retailUnitId = json['retail_unit_id'];
    vipUnitId = json['vip_unit_id'];
    discount = json['discount'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    minWholeQuantity = json['min_whole_quantity'];
    minRetailQuantity = json['min_retail_quantity'];
    minVipQuantity = json['min_vip_quantity'];
    maxWholeQuantity = json['max_whole_quantity'];
    maxRetailQuantity = json['max_retail_quantity'];
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
