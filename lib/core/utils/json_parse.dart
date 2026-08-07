///the api is inconsistent about the json type of its scalars: `role` comes back
///as the string "0", `phone_verified` as a bool, `status` as either 1 or "1",
///and prices as either a number or a string. reading those straight into a
///typed model field throws at runtime, e.g.
///"type 'String' is not a subtype of type 'int'".
///
///every model parses through these helpers so a type change on the backend
///degrades to a fallback instead of crashing the screen.
library;

///parse anything the api may send for an integer field
int? asIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is bool) return value ? 1 : 0;
  if (value is String) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed) ?? double.tryParse(trimmed)?.toInt();
  }
  return null;
}

int asInt(dynamic value, {int fallback = 0}) => asIntOrNull(value) ?? fallback;

///parse anything the api may send for a decimal field (prices, lat/lng)
double? asDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is bool) return value ? 1 : 0;
  if (value is String) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }
  return null;
}

double asDouble(dynamic value, {double fallback = 0}) =>
    asDoubleOrNull(value) ?? fallback;

///parse anything the api may send for a boolean field.
///the api uses true/false, 1/0 and "1"/"0" interchangeably
bool? asBoolOrNull(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final String trimmed = value.trim().toLowerCase();
    if (trimmed.isEmpty) return null;
    if (trimmed == 'true' || trimmed == '1') return true;
    if (trimmed == 'false' || trimmed == '0') return false;
    return null;
  }
  return null;
}

bool asBool(dynamic value, {bool fallback = false}) =>
    asBoolOrNull(value) ?? fallback;

///parse anything the api may send for a text field.
///ids and phone numbers arrive as numbers often enough to matter
String? asStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

String asString(dynamic value, {String fallback = ''}) =>
    asStringOrNull(value) ?? fallback;
