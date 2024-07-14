class ProfileModel {
  List<User>? user;

  ProfileModel({this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(User.fromJson(v));
      });
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
      this.store});

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
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
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
  String? lng;
  String? lat;
  int? userId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Store(
      {this.id,
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
      this.updatedAt});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerName = json['owner_name'];
    storeName = json['store_name'];
    district = json['district'];
    address = json['address'];
    phone = json['phone'];
    lng = json['lng'];
    lat = json['lat'];
    userId = json['user_id'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
