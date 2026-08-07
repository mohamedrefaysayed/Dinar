import 'package:dinar_store/features/home/data/models/profile_model.dart';

/// Validates if the user profile has all required data
class ProfileValidator {
  /// Checks if profile has any missing required fields
  /// Returns true if profile is complete, false if any required field is missing
  static bool isProfileComplete(ProfileModel? profileModel) {
    if (profileModel == null ||
        profileModel.user == null ||
        profileModel.user!.isEmpty) {
      return false;
    }

    final user = profileModel.user!.first;
    final store = user.store;

    // Check user required fields
    if (_isNullOrEmpty(user.phone) || _isNullOrEmpty(user.countryCode)) {
      return false;
    }

    // Check if store exists
    if (store == null) {
      return false;
    }

    // Check store required fields
    if (_isNullOrEmpty(store.ownerName) ||
        _isNullOrEmpty(store.storeName) ||
        _isNullOrEmpty(store.district) ||
        _isNullOrEmpty(store.address) ||
        _isNullOrEmpty(store.phone) ||
        store.lat == null ||
        store.lng == null) {
      return false;
    }

    return true;
  }

  /// Gets list of missing fields for debugging/display purposes
  static List<String> getMissingFields(ProfileModel? profileModel) {
    List<String> missingFields = [];

    if (profileModel == null ||
        profileModel.user == null ||
        profileModel.user!.isEmpty) {
      missingFields.add('بيانات المستخدم');
      return missingFields;
    }

    final user = profileModel.user!.first;
    final store = user.store;

    // Check user fields
    if (_isNullOrEmpty(user.phone)) {
      missingFields.add('رقم الهاتف');
    }
    if (_isNullOrEmpty(user.countryCode)) {
      missingFields.add('رمز الدولة');
    }

    // Check store
    if (store == null) {
      missingFields.add('بيانات المتجر');
      return missingFields;
    }

    // Check store fields
    if (_isNullOrEmpty(store.ownerName)) {
      missingFields.add('اسم صاحب المتجر');
    }
    if (_isNullOrEmpty(store.storeName)) {
      missingFields.add('اسم المتجر');
    }
    if (_isNullOrEmpty(store.district)) {
      missingFields.add('المحافظة');
    }
    if (_isNullOrEmpty(store.address)) {
      missingFields.add('العنوان');
    }
    if (_isNullOrEmpty(store.phone)) {
      missingFields.add('رقم المتجر');
    }
    if (store.lat == null || store.lng == null) {
      missingFields.add('الموقع الجغرافي');
    }

    return missingFields;
  }

  /// Helper method to check if a string is null or empty
  static bool _isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }
}
