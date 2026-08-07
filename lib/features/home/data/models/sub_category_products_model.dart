import 'package:dinar_store/core/utils/json_parse.dart';

class SubCategoryProductsModel {
  Category? category;
  List<Products>? products;

  SubCategoryProductsModel({this.category, this.products});

  ///every caller reads `subCategoryProductsModel.products!` (the products grid,
  ///the whole sub category list, the search filter in the cubit), so the list
  ///defaults to empty instead of null when the api omits 'products'. the key is
  ///also tolerated as a single object: forEach on a map passes (key, value) to
  ///a one argument closure and throws
  SubCategoryProductsModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawCategory = json['category'];
    category = rawCategory is Map<String, dynamic>
        ? Category.fromJson(rawCategory)
        : null;

    final dynamic rawProducts = json['products'];
    if (rawProducts is List) {
      products = rawProducts
          .whereType<Map<String, dynamic>>()
          .map(Products.fromJson)
          .toList();
    } else if (rawProducts is Map<String, dynamic>) {
      products = <Products>[Products.fromJson(rawProducts)];
    } else {
      products = <Products>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
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
  CategorySpecification? categorySpecification;

  Category(
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
      this.updatedAt,
      this.categorySpecification});

  ///the current backend drops 'description' from every category payload and
  ///the screens force unwrap it, so the display text defaults to '' here.
  ///'parent_id' stays nullable because null is what marks a top level category
  Category.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    categoryName = asString(json['category_name'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image']);
    level = asIntOrNull(json['level']);
    parentId = asIntOrNull(json['parent_id']);
    categorySpecificationId = asIntOrNull(json['category_specification_id']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);

    final dynamic rawCategorySpecification = json['category_specification'];
    categorySpecification = rawCategorySpecification is Map<String, dynamic>
        ? CategorySpecification.fromJson(rawCategorySpecification)
        : null;
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
    if (categorySpecification != null) {
      data['category_specification'] = categorySpecification!.toJson();
    }
    return data;
  }
}

class CategorySpecification {
  int? id;
  String? specificationName;
  String? description;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  CategorySpecification(
      {this.id,
      this.specificationName,
      this.description,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  CategorySpecification.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    specificationName = asString(json['specification_name']);
    description = asString(json['description']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['specification_name'] = specificationName;
    data['description'] = description;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Products {
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
  WholeUnit? wholeUnit;
  UnitGroup? unitGroup;
  Category? category;
  Company? company;
  WholeUnit? retailUnit;
  WholeUnit? vipUnit;
  List<RequiredProducts>? requiredProducts;

  Products(
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
      this.maxRetailQuantity,
      this.wholeUnit,
      this.unitGroup,
      this.category,
      this.company,
      this.retailUnit,
      this.vipUnit,
      this.requiredProducts});

  ///the product screens force unwrap nearly everything on this class
  ///(`product.image!`, `product.description!`, `product.retailPrice!`,
  ///`product.minRetailQuantity!`, `product.retailUnit!.unitName!`), and this
  ///backend omits 'discount' entirely plus the unit relations whenever a
  ///product is rebuilt from a search result. so text defaults to '', numbers
  ///default to 0 and the two units the ui dereferences are always built,
  ///empty rather than null.
  ///prices arrive as "0.000000" strings from this backend even though the
  ///fields are declared int, which is why they go through asInt
  Products.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    productName = asString(json['product_name'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image']);
    wholeSalePrice = asInt(json['whole_sale_price']);
    retailPrice = asInt(json['retail_price']);
    vipPrice = asInt(json['vip_price']);
    categoryId = asIntOrNull(json['category_id']);
    companyId = asIntOrNull(json['company_id']);
    unitGroupId = asIntOrNull(json['unit_group_id']);
    wholeUnitId = asInt(json['whole_unit_id']);
    retailUnitId = asInt(json['retail_unit_id']);
    vipUnitId = asIntOrNull(json['vip_unit_id']);

    ///no product carries a 'discount' key on this backend, and the cart totals
    ///treat a missing discount as 0
    discount = asInt(json['discount']);
    status = asIntOrNull(json['status']);

    ///null means "not deleted", so this one stays nullable
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
    minWholeQuantity = asInt(json['min_whole_quantity']);
    minRetailQuantity = asInt(json['min_retail_quantity']);
    minVipQuantity = asInt(json['min_vip_quantity']);
    maxWholeQuantity = asInt(json['max_whole_quantity']);
    maxRetailQuantity = asInt(json['max_retail_quantity']);

    ///`product.wholeUnit!.unitName!` and `product.retailUnit!.unitName!` are
    ///read unguarded by the required products sheet, which is also reachable
    ///for a product rebuilt from a search hit (that json has no unit keys)
    final dynamic rawWholeUnit = json['whole_unit'];
    wholeUnit = WholeUnit.fromJson(rawWholeUnit is Map<String, dynamic>
        ? rawWholeUnit
        : const <String, dynamic>{});

    final dynamic rawRetailUnit = json['retail_unit'];
    retailUnit = WholeUnit.fromJson(rawRetailUnit is Map<String, dynamic>
        ? rawRetailUnit
        : const <String, dynamic>{});

    final dynamic rawUnitGroup = json['unit_group'];
    unitGroup = rawUnitGroup is Map<String, dynamic>
        ? UnitGroup.fromJson(rawUnitGroup)
        : null;

    final dynamic rawCategory = json['category'];
    category = rawCategory is Map<String, dynamic>
        ? Category.fromJson(rawCategory)
        : null;

    final dynamic rawCompany = json['company'];
    company = rawCompany is Map<String, dynamic>
        ? Company.fromJson(rawCompany)
        : null;

    final dynamic rawVipUnit = json['vip_unit'];
    vipUnit = rawVipUnit is Map<String, dynamic>
        ? WholeUnit.fromJson(rawVipUnit)
        : null;

    ///`product.requiredProducts!` is iterated unguarded by the required
    ///products sheet, so an absent key becomes an empty list. a single object
    ///instead of a list is tolerated too
    final dynamic rawRequiredProducts = json['required_products'];
    if (rawRequiredProducts is List) {
      requiredProducts = rawRequiredProducts
          .whereType<Map<String, dynamic>>()
          .map(RequiredProducts.fromJson)
          .toList();
    } else if (rawRequiredProducts is Map<String, dynamic>) {
      requiredProducts = <RequiredProducts>[
        RequiredProducts.fromJson(rawRequiredProducts)
      ];
    } else {
      requiredProducts = <RequiredProducts>[];
    }
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
    if (wholeUnit != null) {
      data['whole_unit'] = wholeUnit!.toJson();
    }
    if (unitGroup != null) {
      data['unit_group'] = unitGroup!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (retailUnit != null) {
      data['retail_unit'] = retailUnit!.toJson();
    }
    if (vipUnit != null) {
      data['vip_unit'] = vipUnit!.toJson();
    }
    if (requiredProducts != null) {
      data['required_products'] =
          requiredProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WholeUnit {
  int? id;
  String? unitName;
  int? eq;
  int? unitGroupId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  WholeUnit(
      {this.id,
      this.unitName,
      this.eq,
      this.unitGroupId,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ///'unit_name' is force unwrapped by the required products sheet, so it
  ///defaults to ''. 'id' stays nullable: it is only ever compared against a
  ///pivot unit id, and an unknown unit must not match unit 0
  WholeUnit.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    unitName = asString(json['unit_name'] ?? json['name']);
    eq = asIntOrNull(json['eq']);
    unitGroupId = asIntOrNull(json['unit_group_id']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit_name'] = unitName;
    data['eq'] = eq;
    data['unit_group_id'] = unitGroupId;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class UnitGroup {
  int? id;
  String? unitGroupName;
  String? description;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  UnitGroup(
      {this.id,
      this.unitGroupName,
      this.description,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  UnitGroup.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    unitGroupName = asString(json['unit_group_name'] ?? json['name']);
    description = asString(json['description']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit_group_name'] = unitGroupName;
    data['description'] = description;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ProductCategory {
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

  ProductCategory(
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

  ///same defaults as Category: this backend sends no 'description' and the
  ///category screens force unwrap it
  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    categoryName = asString(json['category_name'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image']);
    level = asIntOrNull(json['level']);
    parentId = asIntOrNull(json['parent_id']);
    categorySpecificationId = asIntOrNull(json['category_specification_id']);
    status = asIntOrNull(json['status']);
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

class Company {
  int? id;
  String? companyName;
  String? description;
  String? logo;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Company(
      {this.id,
      this.companyName,
      this.description,
      this.logo,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ///some companies come back with no 'logo' and none carry a 'description',
  ///both of which the company screens force unwrap, so they default to ''
  Company.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    companyName = asString(json['company_name'] ?? json['name']);
    description = asString(json['description']);
    logo = asString(json['logo']);
    status = asIntOrNull(json['status']);
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

class RequiredProducts {
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
  Pivot? pivot;
  WholeUnit? wholeUnit;
  WholeUnit? retailUnit;

  RequiredProducts(
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
      this.maxRetailQuantity,
      this.pivot,
      this.wholeUnit,
      this.retailUnit});

  ///the required product container and the cart cubit dereference
  ///`element.pivot!`, `element.retailUnit!.id`, `element.retailPrice!` and
  ///`element.image!` without a guard, so the pivot and both units are always
  ///built and the scalars default instead of staying null
  RequiredProducts.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    productName = asString(json['product_name'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image']);
    wholeSalePrice = asInt(json['whole_sale_price']);
    retailPrice = asInt(json['retail_price']);
    vipPrice = asInt(json['vip_price']);
    categoryId = asIntOrNull(json['category_id']);
    companyId = asIntOrNull(json['company_id']);
    unitGroupId = asIntOrNull(json['unit_group_id']);
    wholeUnitId = asInt(json['whole_unit_id']);
    retailUnitId = asInt(json['retail_unit_id']);
    vipUnitId = asIntOrNull(json['vip_unit_id']);
    discount = asInt(json['discount']);
    status = asIntOrNull(json['status']);

    ///null means "not deleted", so this one stays nullable
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
    minWholeQuantity = asInt(json['min_whole_quantity']);
    minRetailQuantity = asInt(json['min_retail_quantity']);
    minVipQuantity = asInt(json['min_vip_quantity']);
    maxWholeQuantity = asInt(json['max_whole_quantity']);
    maxRetailQuantity = asInt(json['max_retail_quantity']);

    final dynamic rawPivot = json['pivot'];
    pivot = Pivot.fromJson(rawPivot is Map<String, dynamic>
        ? rawPivot
        : const <String, dynamic>{});

    final dynamic rawWholeUnit = json['whole_unit'];
    wholeUnit = WholeUnit.fromJson(rawWholeUnit is Map<String, dynamic>
        ? rawWholeUnit
        : const <String, dynamic>{});

    final dynamic rawRetailUnit = json['retail_unit'];
    retailUnit = WholeUnit.fromJson(rawRetailUnit is Map<String, dynamic>
        ? rawRetailUnit
        : const <String, dynamic>{});
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
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (wholeUnit != null) {
      data['whole_unit'] = wholeUnit!.toJson();
    }
    if (retailUnit != null) {
      data['retail_unit'] = retailUnit!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? productId;
  int? requiredProductId;
  int? unitId;
  int? quantity;
  int? requiredUnitId;
  int? requiredQuantiy;
  int? status;

  Pivot(
      {this.productId,
      this.requiredProductId,
      this.unitId,
      this.quantity,
      this.requiredUnitId,
      this.requiredQuantiy,
      this.status});

  Pivot.fromJson(Map<String, dynamic> json) {
    productId = asInt(json['product_id']);
    requiredProductId = asInt(json['required_product_id']);
    unitId = asInt(json['unit_id']);

    ///'quantity' is the divisor in
    ///`(quantity / product.pivot!.quantity!).floor()` (cart cubit and the
    ///required product container). 0 would make that Infinity and .floor()
    ///throws on Infinity, so a missing quantity falls back to 1 - the only
    ///value that keeps those two call sites from crashing
    quantity = asInt(json['quantity'], fallback: 1);
    requiredUnitId = asInt(json['required_unit_id']);
    requiredQuantiy = asInt(json['required_quantiy']);
    status = asIntOrNull(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['required_product_id'] = requiredProductId;
    data['unit_id'] = unitId;
    data['quantity'] = quantity;
    data['required_unit_id'] = requiredUnitId;
    data['required_quantiy'] = requiredQuantiy;
    data['status'] = status;
    return data;
  }
}
