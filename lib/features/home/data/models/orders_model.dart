class OrdersModel {
  List<DinarOrder>? currentOrders;
  List<DinarOrder>? oldOrders;

  OrdersModel({this.currentOrders, this.oldOrders});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    if (json['current_orders'] != null) {
      currentOrders = <DinarOrder>[];
      json['current_orders'].forEach((v) {
        currentOrders!.add(DinarOrder.fromJson(v));
      });
    }
    if (json['old_orders'] != null) {
      oldOrders = <DinarOrder>[];
      json['old_orders'].forEach((v) {
        oldOrders!.add(DinarOrder.fromJson(v));
      });
    }
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

  DinarOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    status = json['status'];
    tax = json['tax'];
    discount = json['discount'];
    subTotal = json['sub_total'];
    total = json['total'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryTime = json['delivery_time'];
    paymentMethod = json['payment_method'];
    location = json['location'];
    address = json['address'];
    if (json['order_details'] != null) {
      orderDetails = <OrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
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
  String? price;
  String? subTotal;
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

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    unitId = json['unit_id'];
    qty = json['qty'];
    price = json['price'];
    subTotal = json['sub_total'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    products =
        json['products'] != null ? Products.fromJson(json['products']) : null;
    units = json['units'] != null ? Units.fromJson(json['units']) : null;
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

  Products.fromJson(Map<String, dynamic> json) {
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

class Units {
  int? id;
  String? unitName;
  String? eq;
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

  Units.fromJson(Map<String, dynamic> json) {
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
