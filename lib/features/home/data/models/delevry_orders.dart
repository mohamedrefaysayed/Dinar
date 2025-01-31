class DelveryOrdersModel {
  List<CurrentOrders>? currentOrders;
  List<OldOrders>? oldOrders;

  DelveryOrdersModel({this.currentOrders, this.oldOrders});

  DelveryOrdersModel.fromJson(Map<String, dynamic> json) {
    if (json['current_orders'] != null) {
      currentOrders = <CurrentOrders>[];
      json['current_orders'].forEach((v) {
        currentOrders!.add(CurrentOrders.fromJson(v));
      });
    }
    if (json['old_orders'] != null) {
      oldOrders = <OldOrders>[];
      json['old_orders'].forEach((v) {
        oldOrders!.add(OldOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentOrders != null) {
      data['current_orders'] =
          currentOrders!.map((v) => v.toJson()).toList();
    }
    if (oldOrders != null) {
      data['old_orders'] = oldOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentOrders {
  int? id;
  int? userId;
  String? orderDate;
  int? status;
  String? tax;
  String? discount;
  String? deliveryFees;
  String? subTotal;
  String? total;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? deliveryTime;
  String? paymentMethod;
  String? location;
  String? address;
  int? agentId;
  User? user;
  List<OrderDetails>? orderDetails;

  CurrentOrders(
      {this.id,
      this.userId,
      this.orderDate,
      this.status,
      this.tax,
      this.discount,
      this.deliveryFees,
      this.subTotal,
      this.total,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.deliveryTime,
      this.paymentMethod,
      this.location,
      this.address,
      this.agentId,
      this.user,
      this.orderDetails});

  CurrentOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    status = json['status'];
    tax = json['tax'];
    discount = json['discount'];
    deliveryFees = json['delivery_fees'];
    subTotal = json['sub_total'];
    total = json['total'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryTime = json['delivery_time'];
    paymentMethod = json['payment_method'];
    location = json['location'];
    address = json['address'];
    agentId = json['agent_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
    data['delivery_fees'] = deliveryFees;
    data['sub_total'] = subTotal;
    data['total'] = total;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_time'] = deliveryTime;
    data['payment_method'] = paymentMethod;
    data['location'] = location;
    data['address'] = address;
    data['agent_id'] = agentId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (orderDetails != null) {
      data['order_details'] =
          orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? countryCode;
  String? expireAt;
  int? phoneVerified;
  String? tokenDevice;
  String? currentDeviceId;
  String? deletedAt;
  int? role;
  int? status;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.countryCode,
      this.expireAt,
      this.phoneVerified,
      this.tokenDevice,
      this.currentDeviceId,
      this.deletedAt,
      this.role,
      this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    countryCode = json['country_code'];
    expireAt = json['expire_at'];
    phoneVerified = json['phone_verified'];
    tokenDevice = json['token_device'];
    currentDeviceId = json['current_device_id'];
    deletedAt = json['deleted_at'];
    role = json['role'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['country_code'] = countryCode;
    data['expire_at'] = expireAt;
    data['phone_verified'] = phoneVerified;
    data['token_device'] = tokenDevice;
    data['current_device_id'] = currentDeviceId;
    data['deleted_at'] = deletedAt;
    data['role'] = role;
    data['status'] = status;
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
    products = json['products'];
    units = json['units'];
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
    data['products'] = products;
    data['units'] = units;
    return data;
  }
}

class OldOrders {
  int? id;
  int? userId;
  String? orderDate;
  int? status;
  String? tax;
  String? discount;
  String? deliveryFees;
  String? subTotal;
  String? total;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? deliveryTime;
  String? paymentMethod;
  String? location;
  String? address;
  int? agentId;
  String? user;
  List<OrderDetails>? orderDetails;

  OldOrders(
      {this.id,
      this.userId,
      this.orderDate,
      this.status,
      this.tax,
      this.discount,
      this.deliveryFees,
      this.subTotal,
      this.total,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.deliveryTime,
      this.paymentMethod,
      this.location,
      this.address,
      this.agentId,
      this.user,
      this.orderDetails});

  OldOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderDate = json['order_date'];
    status = json['status'];
    tax = json['tax'];
    discount = json['discount'];
    deliveryFees = json['delivery_fees'];
    subTotal = json['sub_total'];
    total = json['total'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryTime = json['delivery_time'];
    paymentMethod = json['payment_method'];
    location = json['location'];
    address = json['address'];
    agentId = json['agent_id'];
    user = json['user'];
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
    data['delivery_fees'] = deliveryFees;
    data['sub_total'] = subTotal;
    data['total'] = total;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_time'] = deliveryTime;
    data['payment_method'] = paymentMethod;
    data['location'] = location;
    data['address'] = address;
    data['agent_id'] = agentId;
    data['user'] = user;
    if (orderDetails != null) {
      data['order_details'] =
          orderDetails!.map((v) => v.toJson()).toList();
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
