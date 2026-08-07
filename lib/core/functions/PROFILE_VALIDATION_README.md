# Profile Validation System

## Overview

This system validates user profile data when the app starts to ensure all required information is complete before allowing access to the main application.

## How It Works

### 1. Splash Screen Flow

When the app launches:

1. The `ManageNavigationCubit` checks if the user has a valid token
2. If token exists (user is logged in):
   - Fetches the user's profile using `ProfileCubit.getProfile()`
   - Validates profile completeness using `ProfileValidator`
   - Navigates based on validation result:
     - **Complete Profile** → Navigate to Home/NavBar
     - **Incomplete Profile** → Navigate to LoginData screen

### 2. Profile Validation

The `ProfileValidator` class checks for the following required fields:

#### User Fields:

- Phone number
- Country code

#### Store Fields:

- Owner name (اسم صاحب المتجر)
- Store name (اسم المتجر)
- District (المحافظة)
- Address (العنوان)
- Phone number (رقم المتجر)
- Latitude and Longitude (الموقع الجغرافي)

### 3. Navigation States

```dart
ManageNavigationInitial        // Initial state
ProfileValidationLoading       // While checking profile
NavigateToLogInView           // No token, user not logged in
NavigateToLoginData           // User logged in but profile incomplete
NavigateToNavBarView          // User logged in with complete profile
```

## Files Modified/Created

### Created:

1. `/lib/core/functions/profile_validator.dart`
   - `isProfileComplete()` - Checks if profile has all required data
   - `getMissingFields()` - Returns list of missing fields for debugging

### Modified:

1. `/lib/features/splash/presentation/view_model/manage_navigation_cubit/manage_navigation_cubit.dart`

   - Added `_validateProfileAndNavigate()` method
   - Integrated profile validation in login flow

2. `/lib/features/splash/presentation/view_model/manage_navigation_cubit/manage_navigation_state.dart`

   - Added `NavigateToLoginData` state
   - Added `ProfileValidationLoading` state

3. `/lib/features/splash/presentation/view/widgets/blocs/splash_view_bloc_listener.dart`
   - Added listener for `NavigateToLoginData` state
   - Shows message to complete profile data

## Usage Example

The validation happens automatically on app launch. No manual intervention needed.

When a user opens the app:

- ✅ **Complete profile** → Goes directly to home
- ⚠️ **Incomplete profile** → Redirected to LoginData screen with a message

## Customization

To modify required fields, edit the `isProfileComplete()` method in `profile_validator.dart`:

```dart
static bool isProfileComplete(ProfileModel? profileModel) {
  // Add or remove field checks here
  if (_isNullOrEmpty(user.phone)) {
    return false;
  }
  // ... more validations
}
```

## Testing

To test the validation:

1. Log in with a user that has incomplete profile data
2. Close and reopen the app
3. You should be redirected to LoginData screen
4. Complete the missing information
5. App will navigate to home on next launch

## Notes

- Validation runs only for logged-in users (with valid token)
- If profile fetch fails, user is directed to LoginData for safety
- Debug mode prints missing fields to console
- Works with both regular users (role=0) and delivery users (role=1)
