import 'package:dinar_store/core/utils/json_parse.dart';

class CategoriesModel {
  List<Categories>? categories;

  CategoriesModel({this.categories});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? categoryName;
  String? description;
  String? image;
  int? level;
  int? parentId;
  int? categorySpecificationId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  List<SubCategories>? subCategories;

  Categories(
      {this.id,
      this.categoryName,
      this.description,
      this.image,
      this.level,
      this.parentId,
      this.categorySpecificationId,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.subCategories});

  ///the current backend omits 'description', 'sub_categories', 'level' and the
  ///timestamps from /categories entirely. the screens force unwrap those
  ///(`category.description!`, `category.subCategories!`) in a dozen places, so
  ///the text fields default to '' and the children to an empty list here
  ///instead of null. that keeps every existing `!` safe rather than leaving
  ///a crash behind each one
  Categories.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    categoryName = asString(json['category_name'] ?? json['name']);
    description = asString(json['description']);
    image = asStringOrNull(json['image']);
    level = asIntOrNull(json['level']);
    parentId = asIntOrNull(json['parent_id']);
    categorySpecificationId = asIntOrNull(json['category_specification_id']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);

    final dynamic rawSubCategories = json['sub_categories'];
    subCategories = rawSubCategories is List
        ? rawSubCategories
            .whereType<Map<String, dynamic>>()
            .map(SubCategories.fromJson)
            .toList()
        : <SubCategories>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['description'] = description;
    data['image'] = image;
    data['level'] = level;
    data['parent_id'] = parentId;
    data['category_specification_id'] = categorySpecificationId;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int? id;
  String? categoryName;
  String? description;
  String? image;
  int? level;
  int? parentId;
  int? categorySpecificationId;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  SubCategories(
      {this.id,
      this.categoryName,
      this.description,
      this.image,
      this.level,
      this.parentId,
      this.categorySpecificationId,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ///see Categories.fromJson: the text fields never come back null so the
  ///`subCategory.description!` force unwraps across the sub category screens
  ///cannot throw
  SubCategories.fromJson(Map<String, dynamic> json) {
    id = asIntOrNull(json['id']);
    categoryName = asString(json['category_name'] ?? json['name']);
    description = asString(json['description']);
    image = asStringOrNull(json['image']);
    level = asIntOrNull(json['level']);
    parentId = asIntOrNull(json['parent_id']);
    categorySpecificationId = asIntOrNull(json['category_specification_id']);
    status = asIntOrNull(json['status']);
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['description'] = description;
    data['image'] = image;
    data['level'] = level;
    data['parent_id'] = parentId;
    data['category_specification_id'] = categorySpecificationId;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}