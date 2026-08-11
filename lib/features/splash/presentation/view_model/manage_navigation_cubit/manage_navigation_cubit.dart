import 'package:dinar_store/core/cubits/app_cubit/cubit/app_cubit_cubit.dart';
import 'package:dinar_store/core/functions/profile_validator.dart';
import 'package:dinar_store/core/functions/show_permitions.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:dinar_store/features/home/presentation/view_model/profile_cubit/profile_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'manage_navigation_state.dart';

class ManageNavigationCubit extends Cubit<ManageNavigationState> {
  ManageNavigationCubit({
    required FlutterSecureStorage secureStorage,
  }) : super(ManageNavigationInitial()) {
    _secureStorage = secureStorage;
  }

  late FlutterSecureStorage _secureStorage;

  Future<void> getAppData(BuildContext context) async {
    String? token = await _secureStorage.read(key: kSecureStorageKey);

    if (token != null) {
      AppCubit.token = token;
    }

    if (kDebugMode) {
      print(token);
    }

    await showPermissions();

    if (AppCubit.token != null) {
      // User is logged in, validate profile data
      await _validateProfileAndNavigate(context);
    } else {
      emit(NavigateToLogInView());
    }
  }

  Future<void> _validateProfileAndNavigate(BuildContext context) async {
    try {
      // Show loading state
      emit(ProfileValidationLoading());

      // Fetch profile data with the stored token
      await context.read<ProfileCubit>().getProfile(context: context);

      final ProfileState profileState = context.read<ProfileCubit>().state;

      // The profile fetch failed, so we could not confirm the session. The
      // usual cause after the api base url changed is a token that belongs to
      // the retired backend: the new one answers /get-user with 401
      // "Unauthenticated". Dropping the user on the store-registration form
      // (NavigateToLoginData) only fails again on save, so re-authenticate
      // instead. For a 401/403 we also wipe the dead token so the next launch
      // starts clean, exactly like a brand new install.
      if (profileState is ProfileFaliuer) {
        if (_isAuthFailure(profileState.statusCode)) {
          await _clearSession();
        }
        if (kDebugMode) {
          print(
              'Profile validation failed (status ${profileState.statusCode}): '
              '${profileState.errMessage}. Routing to login.');
        }
        emit(NavigateToLogInView());
        return;
      }

      // Get the profile from the cubit
      final profileModel = ProfileCubit.profileModel;

      // Validate profile completeness
      if (ProfileValidator.isProfileComplete(profileModel)) {
        // Profile is complete, navigate to home
        emit(NavigateToNavBarView());
      } else {
        // Profile has missing data, navigate to login data screen
        if (kDebugMode) {
          final missingFields = ProfileValidator.getMissingFields(profileModel);
          print(
              'Profile incomplete. Missing fields: ${missingFields.join(', ')}');
        }
        emit(NavigateToLoginData());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error validating profile: $e');
      }
      // Session could not be confirmed. Send the user through login rather than
      // the registration form, which needs a valid token to save.
      emit(NavigateToLogInView());
    }
  }

  ///a 401/403 means the backend rejected the stored token (expired, revoked, or
  ///issued by the retired domain), not that the profile is incomplete
  bool _isAuthFailure(int? statusCode) =>
      statusCode == 401 || statusCode == 403;

  ///drop the dead token so the app stops replaying it on every launch
  Future<void> _clearSession() async {
    await _secureStorage.delete(key: kSecureStorageKey);
    AppCubit.token = null;
  }
}
