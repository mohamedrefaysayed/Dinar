class CartItemsModel {
  List<CartItem>? cart;

  CartItemsModel({this.cart});

  CartItemsModel.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      cart = <CartItem>[];
      json['cart'].forEach((v) {
        cart!.add(CartItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  int? id;
  int? productId;
  int? userId;
  int? unitId;
  int? quantity;
  int? price;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? isRequired;
  int? refCartId;
  Product? product;
  Unit? unit;
  bool loading = false;
  bool updating = false;

  CartItem({
    this.id,
    this.productId,
    this.userId,
    this.unitId,
    this.quantity,
    this.price,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.isRequired,
    this.refCartId,
    this.product,
    this.unit,
    required this.loading,
    required this.updating,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    unitId = json['unit_id'];
    quantity = json['quantity'];
    price = json['price'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isRequired = json['is_required'];
    refCartId = json['ref_cart_id'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    unit = json['unit'] != null ? Unit.fromJson(json['unit']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['unit_id'] = unitId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_required'] = isRequired;
    data['ref_cart_id'] = refCartId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? productName;
  String? description;
  String? image;
  String? wholeSalePrice;
  String? retailPrice;
  String? vipPrice;
  int? categoryId;
  int? companyId;
  int? unitGroupId;
  int? wholeUnitId;
  int? retailUnitId;
  int? vipUnitId;
  String? discount;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? minWholeQuantity;
  String? minRetailQuantity;
  String? minVipQuantity;
  String? maxWholeQuantity;
  String? maxRetailQuantity;

  Product(
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

  Product.fromJson(Map<String, dynamic> json) {
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

class Unit {
  int? id;
  String? unitName;
  String? eq;
  int? unitGroupId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Unit(
      {this.id,
      this.unitName,
      this.eq,
      this.unitGroupId,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unit_name'];
    eq = json['eq'];
    unitGroupId = json['unit_group_id'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
