import 'package:dinar_store/core/utils/json_parse.dart';

class ProfileModel {
  List<User>? user;

  ProfileModel({this.user});

  ///'user' arrives as a single object from /login, /verify and /get-user, but
  ///older builds of the api wrapped it in a list. calling forEach on a map
  ///passes (key, value) to a one argument closure and throws, so both shapes
  ///are normalised into the list the ui already expects
  ProfileModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawUser = json['user'];
    if (rawUser is List) {
      user = rawUser
          .whereType<Map<String, dynamic>>()
          .map(User.fromJson)
          .toList();
    } else if (rawUser is Map<String, dynamic>) {
      user = <User>[User.fromJson(rawUser)];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.map((v) => v.toJson()).toList();
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
  Store? store;

  User({
    this.id,
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
    this.store,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    name = asStringOrNull(json['name']);
    email = asStringOrNull(json['email']);
    phone = asStringOrNull(json['phone']);
    emailVerifiedAt = asStringOrNull(json['email_verified_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
    countryCode = asStringOrNull(json['country_code']);
    expireAt = asStringOrNull(json['expire_at']);

    ///the api sends this as a bool, not the 1/0 this field was written for
    phoneVerified = asIntOrNull(json['phone_verified']);
    tokenDevice = asStringOrNull(json['token_device']);
    currentDeviceId = asStringOrNull(json['current_device_id']);
    deletedAt = asStringOrNull(json['deleted_at']);
    final dynamic rawStore = json['store'];
    store = rawStore is Map<String, dynamic> ? Store.fromJson(rawStore) : null;
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
    if (store != null) {
      data['store'] = store!.toJson();
    }
    return data;
  }
}

class Store {
  int? id;
  String? ownerName;
  String? storeName;
  String? district;
  String? address;
  String? phone;
  double? lng;
  double? lat;
  int? userId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Store({
    this.id,
    this.ownerName,
    this.storeName,
    this.district,
    this.address,
    this.phone,
    this.lng,
    this.lat,
    this.userId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Store.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    ownerName = asStringOrNull(json['owner_name']);
    storeName = asStringOrNull(json['store_name']);
    district = asStringOrNull(json['district']);
    address = asStringOrNull(json['address']);
    phone = asStringOrNull(json['phone']);

    ///lat/lng come back as numbers here but as strings from /address
    lng = asDoubleOrNull(json['lng']);
    lat = asDoubleOrNull(json['lat']);
    userId = asIntOrNull(json['user_id']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['owner_name'] = ownerName;
    data['store_name'] = storeName;
    data['district'] = district;
    data['address'] = address;
    data['phone'] = phone;
    data['lng'] = lng;
    data['lat'] = lat;
    data['user_id'] = userId;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
