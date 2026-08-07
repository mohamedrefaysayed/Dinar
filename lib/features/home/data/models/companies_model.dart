import 'package:dinar_store/core/utils/json_parse.dart';

class CompaniesModel {
  List<Companies>? companies;

  CompaniesModel({this.companies});

  ///`companiesModel.companies!` is force unwrapped by the home grid, the all
  ///companies screen and the search cubit, so the list is always materialised
  ///here. the key may be absent on the current backend, and a single company
  ///is occasionally sent as a bare object instead of a one element list - both
  ///degrade to a (possibly empty) list rather than null
  CompaniesModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawCompanies = json['companies'];
    if (rawCompanies is List) {
      companies = rawCompanies
          .whereType<Map<String, dynamic>>()
          .map(Companies.fromJson)
          .toList();
    } else if (rawCompanies is Map<String, dynamic>) {
      companies = <Companies>[Companies.fromJson(rawCompanies)];
    } else {
      companies = <Companies>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companies != null) {
      data['companies'] = companies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Companies {
  int? id;
  String? companyName;
  String? description;
  String? logo;
  int? status; // Change status to int
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Companies(
      {this.id,
      this.companyName,
      this.description,
      this.logo,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ///the current backend omits 'description' on every company and 'logo' on
  ///some of them, while the screens force unwrap both (`company.description!`,
  ///`company.logo!` in all_company_container and companies_view). the text
  ///fields therefore default to '' so each existing `!` stays safe, and 'id'
  ///defaults to 0 because `company.id!` feeds the hero tag and the
  ///getCompanyWithProduct request. 'status' and the timestamps are never
  ///displayed, so they pass through nullable and keep toJson unchanged
  Companies.fromJson(Map<String, dynamic> json) {
    id = asInt(json['id']);
    companyName = asString(json['company_name'] ?? json['name']);
    description = asString(json['description']);
    logo = asString(json['logo'] ?? json['image']);
    status = asIntOrNull(json['status']); // Parse status to int
    deletedAt = asStringOrNull(json['deleted_at']);
    createdAt = asStringOrNull(json['created_at']);
    updatedAt = asStringOrNull(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['description'] = description;
    data['logo'] = logo;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
