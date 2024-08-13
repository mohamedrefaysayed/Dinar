import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';

class AdsModel {
  List<Ads>? ads;

  AdsModel({this.ads});

  AdsModel.fromJson(Map<String, dynamic> json) {
    if (json['ads'] != null) {
      ads = <Ads>[];
      json['ads'].forEach((v) {
        ads!.add( Ads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ads != null) {
      data['ads'] = ads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ads {
  int? id;
  String? title;
  String? description;
  String? image;
  String? adType;
  String? expirationTime;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? productId;
  Products? product;

  Ads(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.adType,
      this.expirationTime,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.product});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    adType = json['ad_type'];
    expirationTime = json['expiration_time'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productId = json['product_id'];
    product =
        json['product'] != null ? Products.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['ad_type'] = adType;
    data['expiration_time'] = expirationTime;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_id'] = productId;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}
