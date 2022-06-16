// lib\services\auth\auth_provider.dart
import "package:mynotes/services/auth/auth_user.dart";

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> create({required String email, required String password});
  Future<void> sendEmailVerification();
  Future<void> logout();
}
