import 'package:dinar_store/core/utils/json_parse.dart';

class SendOrderModel {
  int? status;
  int? discount;
  int? tax;
  String? address;
  String? location;
  String? deliveryTime;
  String? paymentMethod;
  String? deliveryFees;
  String? notes;

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
    this.deliveryFees,
    this.notes,
  });

  ///this model is the *outbound* body of POST /orders: OrderCubit.storeOrder
  ///builds a plain map, runs it through this constructor and posts toJson().
  ///so the failure mode here is not a missing display field but a type
  ///mismatch - 'delivery_fees' declared String? but sent as a number, or a
  ///price arriving as "0.000000" - which used to throw
  ///"type 'String' is not a subtype of type 'int'" while assembling the
  ///request. every scalar now goes through the json_parse helpers, the text
  ///fields fall back to '' and the order lines to an empty list.
  SendOrderModel.fromJson(Map<String, dynamic> json) {
    ///left nullable on purpose: the caller never supplies 'status' and the
    ///server assigns the initial order state. defaulting it to 0 would post
    ///an explicit status and change how the order is created
    status = asIntOrNull(json['status']);
    discount = asInt(json['discount']);
    tax = asInt(json['tax']);
    address = asString(json['address']);
    location = asString(json['location']);
    deliveryTime = asString(json['delivery_time']);
    paymentMethod = asString(json['payment_method']);
    deliveryFees = asString(json['delivery_fees']);
    notes = asString(json['notes']);

    ///tolerate 'order_details' being absent, a single object instead of a
    ///list, or holding Map<dynamic, dynamic> entries. the old
    ///`json['order_details'].forEach` threw on all three
    final dynamic rawOrderDetails = json['order_details'];
    final List<dynamic> rawOrderLines = rawOrderDetails is List
        ? rawOrderDetails
        : rawOrderDetails is Map
            ? <dynamic>[rawOrderDetails]
            : const <dynamic>[];
    orderDetails = rawOrderLines
        .whereType<Map>()
        .map((v) => SendOrderDetails.fromJson(Map<String, dynamic>.from(v)))
        .toList();
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
    data['delivery_fees'] = deliveryFees;
    data['notes'] = notes;

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
  String? unitType;

  SendOrderDetails({
    this.productId,
    this.unitId,
    this.qty,
    this.price,
    this.unitType,
  });

  ///one line of the outbound order. 'price' is declared int? but the api and
  ///the cart both hand prices around as "0.000000" strings, so it is parsed
  ///rather than cast. the ids stay nullable like every other identifier in
  ///the models - a fabricated id of 0 would post a line for a product that
  ///does not exist
  SendOrderDetails.fromJson(Map<String, dynamic> json) {
    productId = asIntOrNull(json['product_id']);
    unitId = asIntOrNull(json['unit_id']);
    qty = asInt(json['qty']);
    price = asInt(json['price']);
    unitType = asString(json['unit_type']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['unit_id'] = unitId;
    data['qty'] = qty;
    data['price'] = price;
    data['unit_type'] = unitType;
    return data;
  }
}
