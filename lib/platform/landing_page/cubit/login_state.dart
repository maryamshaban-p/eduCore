part of 'login_cubit.dart';

class LoginState {
  final int selectedRole;
  final int? hoveredRole;
  final bool obscurePassword;
  final bool isLoading;
  final bool loginSuccess;
  final String? loggedInRole;   // "Teacher" | "Moderator" after success
  final String? errorMessage;

  const LoginState({
    this.selectedRole    = 0,
    this.hoveredRole,
    this.obscurePassword = true,
    this.isLoading       = false,
    this.loginSuccess    = false,
    this.loggedInRole,
    this.errorMessage,
  });

  LoginState copyWith({
    int?    selectedRole,
    int?    hoveredRole,
    bool?   obscurePassword,
    bool?   isLoading,
    bool?   loginSuccess,
    String? loggedInRole,
    String? errorMessage,
    bool    clearHover = false,
  }) {
    return LoginState(
      selectedRole:    selectedRole    ?? this.selectedRole,
      hoveredRole:     clearHover ? null : hoveredRole ?? this.hoveredRole,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading:       isLoading       ?? this.isLoading,
      loginSuccess:    loginSuccess    ?? this.loginSuccess,
      loggedInRole:    loggedInRole    ?? this.loggedInRole,
      errorMessage:    errorMessage,   // always replace (null clears it)
    );
  }
}