import 'package:dinar_store/core/utils/json_parse.dart';

///normalise a nested collection: the api sometimes drops the key entirely and
///sometimes sends a single object where a list is declared. calling forEach on
///a map passes (key, value) to a one argument closure and throws, so both
///shapes collapse into the list the ui already force unwraps
List<T> _asModelList<T>(
  dynamic value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (value is List) {
    return value.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }
  if (value is Map<String, dynamic>) {
    return <T>[fromJson(value)];
  }
  return <T>[];
}

///nested single objects arrive as a map, occasionally as a one element list,
///and are omitted outright by the current backend
Map<String, dynamic>? _asJsonObject(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is List) {
    for (final dynamic item in value) {
      if (item is Map<String, dynamic>) return item;
    }
  }
  return null;
}

///money fields are declared String but reach the ui through `double.parse`
///(order_row.dart: `double.parse(order.total!)`). the api sends them as
///"12.50", as 12.5 and sometimes not at all, so the raw text is kept whenever
///it is parsable and degrades to '0' instead of throwing a FormatException
String _asAmountString(dynamic value) {
  final String raw = asString(value).trim();
  if (double.tryParse(raw) != null) return raw;
  return asDoubleOrNull(value)?.toString() ?? '0';
}

class OrdersModel {
  List<DinarOrder>? currentOrders;
  List<DinarOrder>? oldOrders;

  OrdersModel({this.currentOrders, this.oldOrders});

  ///both buckets default to an empty list: orders_view and delevry_orders read
  ///`ordersModel!.currentOrders!.isNotEmpty` / `oldOrders!.length` behind a
  ///null check on the model only, so a missing key used to crash the screen
  ///instead of showing the "no orders" state
  OrdersModel.fromJson(Map<String, dynamic> json) {
    currentOrders = _asModelList(json['current_orders'], DinarOrder.fromJson);
    oldOrders = _asModelList(json['old_orders'], DinarOrder.fromJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentOrders != null) {
      data['current_orders'] = currentOrders!.map((v) => v.toJson()).toList();
    }
    if (oldOrders != null) {
      data['old_orders'] = oldOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DinarOrder {
  int? id;
  int? userId;
  String? orderDate;
  int? status;
  String? tax;
  String? discount;
  String? subTotal;
  String? total;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? deliveryTime;
  String? paymentMethod;
  String? location;
  String? address;
  List<OrderDetails>? orderDetails;

  DinarOrder(
      {this.id,
      this.userId,
      this.orderDate,
      this.status,
      this.tax,
      this.discount,
      this.subTotal,
      this.total,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.deliveryTime,
      this.paymentMethod,
      this.location,
      this.address,
      this.orderDetails});

  ///`id`, `status`, `total` and `order_details` are force unwrapped by
  ///order_row and whole_order_view, so they get real defaults here. `location`,
  ///`address` and `delivery_time` stay nullable on purpose: those screens
  ///branch on null to pick the fallback map position, the "لا يوجد عنوان"
  ///label and whether to render the eta row at all
  DinarOrder.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    userId = asIntOrNull(json['user_id']);
    orderDate = asStringOrNull(json['order_date']);

    ///`order.status!` and `int.parse(status!.toString())` run on every order
    status = asInt(json['status']);
    tax = _asAmountString(json['tax']);
    discount = _asAmountString(json['discount']);
    subTotal = _asAmountString(json['sub_total']);
    total = _asAmountString(json['total']);

    ///null means "not deleted", the ui must keep telling the two apart
    deletedAt = asStringOrNull(json['deleted_at']);

    ///timestamps feed DateTime.parse, where '' throws just as loudly as null
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
    deliveryTime = asStringOrNull(json['delivery_time']);
    paymentMethod = asString(json['payment_method']);
    location = asStringOrNull(json['location']);
    address = asStringOrNull(json['address']);
    orderDetails = _asModelList(json['order_details'], OrderDetails.fromJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_date'] = orderDate;
    data['status'] = status;
    data['tax'] = tax;
    data['discount'] = discount;
    data['sub_total'] = subTotal;
    data['total'] = total;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_time'] = deliveryTime;
    data['payment_method'] = paymentMethod;
    data['location'] = location;
    data['address'] = address;
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int? id;
  int? orderId;
  int? productId;
  int? unitId;
  int? qty;
  int? price;
  int? subTotal;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Products? products;
  Units? units;

  OrderDetails(
      {this.id,
      this.orderId,
      this.productId,
      this.unitId,
      this.qty,
      this.price,
      this.subTotal,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.products,
      this.units});

  ///`products` stays nullable because order_row and order_product_row branch on
  ///`products != null` to decide whether to render the row at all. `units` is
  ///the opposite case: order_product_row reads `units!.unitName` with no guard,
  ///so an absent 'units' key now yields an empty Units instead of a crash
  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    orderId = asIntOrNull(json['order_id']);
    productId = asIntOrNull(json['product_id']);
    unitId = asIntOrNull(json['unit_id']);

    ///printed straight into the product line, so it must not read "null"
    qty = asInt(json['qty']);

    ///prices come back as "12.50" as often as 12
    price = asIntOrNull(json['price']);
    subTotal = asIntOrNull(json['sub_total']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);

    final Map<String, dynamic>? rawProducts = _asJsonObject(json['products']);
    products = rawProducts != null ? Products.fromJson(rawProducts) : null;
    units = Units.fromJson(_asJsonObject(json['units']) ?? <String, dynamic>{});
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['unit_id'] = unitId;
    data['qty'] = qty;
    data['price'] = price;
    data['sub_total'] = subTotal;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (products != null) {
      data['products'] = products!.toJson();
    }
    if (units != null) {
      data['units'] = units!.toJson();
    }
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
      this.maxRetailQuantity});

  ///'image' keeps its null because order_product_row checks
  ///`products!.image != null` before handing the url to the network image.
  ///the current backend sends no 'discount' at all, so it settles on 0 - the
  ///same value the cart already substitutes with `?? 0`
  Products.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    productName = asString(json['product_name'] ?? json['name']);
    description = asString(json['description']);
    image = asStringOrNull(json['image']);

    ///prices arrive as "0.000000" strings from this backend
    wholeSalePrice = asIntOrNull(json['whole_sale_price']);
    retailPrice = asIntOrNull(json['retail_price']);
    vipPrice = asIntOrNull(json['vip_price']);
    categoryId = asIntOrNull(json['category_id']);
    companyId = asIntOrNull(json['company_id']);
    unitGroupId = asIntOrNull(json['unit_group_id']);
    wholeUnitId = asIntOrNull(json['whole_unit_id']);
    retailUnitId = asIntOrNull(json['retail_unit_id']);
    vipUnitId = asIntOrNull(json['vip_unit_id']);
    discount = asInt(json['discount']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
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

class Units {
  int? id;
  String? unitName;
  int? eq;
  int? unitGroupId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Units(
      {this.id,
      this.unitName,
      this.eq,
      this.unitGroupId,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ///`unit_name` lands in the product line of every order, so it defaults to ''
  ///rather than printing "null" or throwing behind `units!.unitName`
  Units.fromJson(Map<String, dynamic> json) {
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
