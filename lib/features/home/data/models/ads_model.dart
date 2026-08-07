import 'package:dinar_store/core/utils/json_parse.dart';
import 'package:dinar_store/features/home/data/models/sub_category_products_model.dart';

class AdsModel {
  List<Ads>? ads;

  AdsModel({this.ads});

  ///the ads carousel force unwraps the list four times
  ///(`state.adsModel.ads!.isNotEmpty`, `.length`, `[itemIndex]`, `.asMap()`),
  ///so the list is never left null here: an absent 'ads' key degrades to the
  ///"no ads right now" placeholder instead of a null check crash. a single
  ///object under 'ads' is accepted as a one element list because the api
  ///collapses single row collections
  AdsModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawAds = json['ads'];
    if (rawAds is List) {
      ads = rawAds.whereType<Map<String, dynamic>>().map(Ads.fromJson).toList();
    } else if (rawAds is Map<String, dynamic>) {
      ads = <Ads>[Ads.fromJson(rawAds)];
    } else {
      ads = <Ads>[];
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

  ///every field the ads carousel force unwraps is given a fallback rather than
  ///left null: `ads[i].image!` feeds the network image and `ads[i].productId!`
  ///is passed to ProductViewInAdds. an ad served without an image now renders
  ///the error icon and one without a product id opens an empty product screen,
  ///which both beat "Null check operator used on a null value" on the home
  ///screen. the current backend also titles ads under 'name' and serves the
  ///picture under 'image_url'/'image_full' when 'image' is missing, so those
  ///aliases are read as fallbacks
  Ads.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    title = asString(json['title'] ?? json['name']);
    description = asString(json['description']);
    image = asString(json['image'] ?? json['image_url'] ?? json['image_full']);
    adType = asString(json['ad_type']);
    expirationTime = asStringOrNull(json['expiration_time']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
    productId = asInt(json['product_id']);

    ///'product' is absent on plain banner ads, so it stays null and the
    ///guard in toJson keeps meaning what it says
    final dynamic rawProduct = json['product'];
    product = rawProduct is Map<String, dynamic>
        ? Products.fromJson(rawProduct)
        : null;
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
