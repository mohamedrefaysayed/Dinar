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

      // Fetch profile data
      await context.read<ProfileCubit>().getProfile(context: context);

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
      // On error, navigate to login data to be safe
      emit(NavigateToLoginData());
    }
  }
}
