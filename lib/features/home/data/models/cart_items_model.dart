import 'package:dinar_store/core/utils/json_parse.dart';

class CartItemsModel {
  List<CartItem>? cart;
  String? deliveryFees;
  String? minOrder;

  CartItemsModel({
    this.cart,
    this.deliveryFees,
    this.minOrder,
  });

  ///'cart' is force unwrapped by every caller (`cartItems.cart!` in
  ///CartCubit.getAllItems/deleteItem, `cartItemsModel!.cart!.isNotEmpty` in
  ///cart_view), so an omitted key has to degrade to an empty list rather than
  ///null. a single object is accepted too: forEach on a map passes two
  ///arguments to a one argument closure and throws.
  ///
  ///'delivery_fees' is force unwrapped as well (`cartItems.deliveryFees!`) and
  ///is posted back to the api as an order field, so it falls back to '0'
  ///instead of '' - '' would both render as an empty price and be rejected by
  ///the numeric column on POST /orders.
  CartItemsModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawCart = json['cart'];
    if (rawCart is List) {
      cart = rawCart
          .whereType<Map<String, dynamic>>()
          .map(CartItem.fromJson)
          .toList();
    } else if (rawCart is Map<String, dynamic>) {
      cart = <CartItem>[CartItem.fromJson(rawCart)];
    } else {
      cart = <CartItem>[];
    }

    deliveryFees = asString(json['delivery_fees'], fallback: '0');

    ///left nullable on purpose: cart_view reads it as
    ///`int.parse(minOrder ?? "400000")`, so a null selects the 400000 default
    ///while an empty string would throw a FormatException on checkout
    minOrder = asStringOrNull(json['min_order']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    data['delivery_fees'] = deliveryFees;
    data['min_order'] = minOrder;
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
  String? unitType;
  bool loading = false;
  bool updating = false;
  bool isRetailed = false;

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
    this.unitType,
    required this.loading,
    required this.updating,
    required this.isRetailed,
  });

  ///id/product_id/unit_id/quantity/price/unit_type are all force unwrapped
  ///downstream - `cartItem.id!` when deleting a row, and
  ///`productId!/unitId!/quantity!/price!/unitType!` when the cart is turned
  ///into order details - so they default instead of staying null.
  ///
  ///defaulting product_id/unit_id does not break the "was a match found"
  ///check in CartCubit.summedItemsFunc (`existingItem.productId != null`):
  ///that sentinel is built by the CartItem() constructor, not by fromJson, so
  ///it still carries null and is still distinguishable from a parsed row.
  ///
  ///prices are declared int here while the api sends them as "1500.00" style
  ///strings; asInt parses through double and truncates rather than throwing
  ///"type 'String' is not a subtype of type 'int'". the declared type cannot
  ///change without breaking the callers that pass price! into an int field.
  CartItem.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    productId = asInt(json['product_id']);
    userId = asIntOrNull(json['user_id']);
    unitId = asInt(json['unit_id']);
    quantity = asInt(json['quantity']);
    price = asInt(json['price']);
    status = asIntOrNull(json['status']);

    ///null means "not deleted", so this one keeps its null
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);

    ///cart_item_row branches on `isRequired == 0` to decide whether the row
    ///can be deleted. 0 is the api's value for a normal, user added line, so a
    ///missing key has to read as 0 - falling through to the "required" branch
    ///would hide the delete button on every row in the cart
    isRequired = asInt(json['is_required']);

    ///null here means "this line was not pulled in by another product"
    refCartId = asIntOrNull(json['ref_cart_id']);
    unitType = asString(json['unit_type']);

    ///kept nullable: CartCubit reads `element.product?.discount ?? 0`.
    ///the type guard also covers the api sending an id or a list here instead
    ///of an object, which would throw inside fromJson
    final dynamic rawProduct = json['product'];
    product =
        rawProduct is Map<String, dynamic> ? Product.fromJson(rawProduct) : null;

    final dynamic rawUnit = json['unit'];
    unit = rawUnit is Map<String, dynamic> ? Unit.fromJson(rawUnit) : null;
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
    data['unit_type'] = unitType;
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

  ///cart_item_row prints `product!.productName!`, `product!.description!` and
  ///feeds `product!.image!` to the network image, so the three text fields
  ///default to ''. the current backend sends no 'description' at all.
  ///
  ///the prices are interpolated straight into the row and 'discount' is not
  ///sent by this backend at all, so the money fields default to 0 - null
  ///rendered as the literal text "null.د" and made the cart total unreadable
  Product.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    productName = asString(json['product_name'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image']);
    wholeSalePrice = asInt(json['whole_sale_price']);
    retailPrice = asInt(json['retail_price']);
    vipPrice = asInt(json['vip_price']);

    ///foreign keys: nothing reads them off a cart line, and a fabricated 0
    ///would look like a real row id, so these stay null when absent
    categoryId = asIntOrNull(json['category_id']);
    companyId = asIntOrNull(json['company_id']);
    unitGroupId = asIntOrNull(json['unit_group_id']);
    wholeUnitId = asIntOrNull(json['whole_unit_id']);
    retailUnitId = asIntOrNull(json['retail_unit_id']);
    vipUnitId = asIntOrNull(json['vip_unit_id']);
    discount = asInt(json['discount']);
    status = asIntOrNull(json['status']);

    ///null means "not deleted"
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);

    ///order limits are not applied to an existing cart line; null keeps
    ///"no limit configured" distinct from a limit of 0, which would read as
    ///"nothing may be ordered"
    minWholeQuantity = asIntOrNull(json['min_whole_quantity']);
    minRetailQuantity = asIntOrNull(json['min_retail_quantity']);
    minVipQuantity = asIntOrNull(json['min_vip_quantity']);
    maxWholeQuantity = asIntOrNull(json['max_whole_quantity']);
    maxRetailQuantity = asIntOrNull(json['max_retail_quantity']);
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
  int? eq;
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

  ///`cartItem.unit!.unitName!` is printed on every cart row, so the name
  ///defaults to ''. 'eq' arrives as "1.000000" from this backend, which is why
  ///it is parsed rather than read straight into an int
  Unit.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    unitName = asString(json['unit_name'] ?? json['name']);
    eq = asIntOrNull(json['eq']);
    unitGroupId = asIntOrNull(json['unit_group_id']);
    status = asIntOrNull(json['status']);

    ///null means "not deleted"
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
