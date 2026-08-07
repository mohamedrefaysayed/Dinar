part of 'manage_navigation_cubit.dart';

sealed class ManageNavigationState {}

final class ManageNavigationInitial extends ManageNavigationState {}

final class NavigateToQrView extends ManageNavigationState {}

final class NavigateToLogInView extends ManageNavigationState {}

final class NavigateToLoginData extends ManageNavigationState {}

final class NavigateToNavBarView extends ManageNavigationState {}

final class ProfileValidationLoading extends ManageNavigationState {}
