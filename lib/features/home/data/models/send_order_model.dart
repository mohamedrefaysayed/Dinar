class SendOrderModel {
  int? status;
  int? discount;
  int? tax;
  String? address;
  String? location;
  String? deliveryTime;
  String? paymentMethod;

  List<SendOrderDetails>? orderDetails;

  SendOrderModel({
    this.status,
    this.discount,
    this.tax,
    this.address,
    this.orderDetails,
    this.location,
    this.deliveryTime,
    this.paymentMethod,
  });

  SendOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    discount = json['discount'];
    tax = json['tax'];
    address = json['address'];
    location = json['location'];
    deliveryTime = json['delivery_time'];
    paymentMethod = json['payment_method'];
    if (json['order_details'] != null) {
      orderDetails = <SendOrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(SendOrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['discount'] = discount;
    data['tax'] = tax;
    data['address'] = address;
    data['location'] = location;
    data['delivery_time'] = deliveryTime;
    data['payment_method'] = paymentMethod;
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SendOrderDetails {
  int? productId;
  int? unitId;
  int? qty;
  int? price;

  SendOrderDetails({
    this.productId,
    this.unitId,
    this.qty,
    this.price,
  });

  SendOrderDetails.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    unitId = json['unit_id'];
    qty = json['qty'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['unit_id'] = unitId;
    data['qty'] = qty;
    data['price'] = price;
    return data;
  }
}
