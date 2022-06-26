// lib\services\auth\bloc\auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState(
      {required this.isLoading, this.loadingText = "Please wait a moment..."});
}

// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;

  const AuthStateLoggedIn({required this.user, required bool isLoading})
      : super(isLoading: isLoading);
}

// class AuthStateLoginFailure extends AuthState {
//   final Exception exception;

//   const AuthStateLoginFailure(this.exception);
// }

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  // final bool isLoading;

  const AuthStateLoggedOut({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);

  @override
  List<Object?> get props => [exception, isLoading];
}

// this is replaced by logged out.exception
// class AuthStateLogoutFailure extends AuthState {
//   final Exception exception;

//   const AuthStateLogoutFailure(this.exception);
// }

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({required this.exception, required isLoading})
      : super(isLoading: isLoading);
}