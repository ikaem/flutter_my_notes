// lib\services\auth\auth_service.dart
import "package:mynotes/services/auth/auth_user.dart";
import "package:mynotes/services/auth/auth_provider.dart";

// we will probide our won auth priovider - this will be firebase uath provider prolly
class AuthService implements AuthProvider {
  final AuthProvider authProvider;

  AuthService(this.authProvider);

  @override
  Future<AuthUser> create({required String email, required String password}) {
    return authProvider.create(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => authProvider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    return authProvider.logIn(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return authProvider.logout();
  }

  @override
  Future<void> sendEmailVerification() {
    return authProvider.sendEmailVerification();
  }
}
