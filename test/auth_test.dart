// test\auth_test.dart
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import "package:test/test.dart";

class NotInitializedException implements Exception {}

void main() {
  group("Mock Authentication", () {
// tests go here
    final provider = MockAuthProvider();

    test("should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });

    test("should not log out if not initialized", () {
      expect(provider.logout(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test("should be able to get initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("should have no user after app initializing", () async {
      expect(provider._user, null);
    });

    test("should be able to initialize in less than 2 seconds", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("should throw an error if we create user with bad email", () async {
      final badEmailUser =
          provider.create(email: "foo@bar.com", password: "goodpass");

      expect(badEmailUser, throwsA(TypeMatcher<UserNotFoundAuthException>()));
    });

    test("should throw an error if we create user with bad email", () async {
      final badPassUser =
          provider.create(email: "foo@barr.com", password: "foobar");

      expect(badPassUser, throwsA(TypeMatcher<WrongPasswordAuthException>()));
    });

    test("should create a user if all good", () async {
      final goodUser =
          await provider.create(email: "good@barr.com", password: "goodpass");

      expect(goodUser, provider.currentUser);
    });

    test("should have user with unverified email", () async {
      expect(provider.currentUser?.isEmailVerified, false);
    });

    test("should be possible to verify a logged in user", () async {
      await provider.sendEmailVerification();
      expect(provider.currentUser, isNotNull);
      expect(provider.currentUser?.isEmailVerified, true);
    });

    test("should be possible to log out and log back in", () async {
      await provider.logout();
      await provider.logIn(email: "email", password: "password");
      expect(provider.currentUser, isNotNull);
    });
  });
}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> create({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));

    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    // TODO: implement initialize
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();

    AuthUser user = AuthUser(id: "", isEmailVerified: false, email: email);
    _user = user;

    // await Future.delayed(const Duration(seconds: 1));
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();

    const newUser = AuthUser(id: "", isEmailVerified: true, email: "");
    _user = newUser;
  }
}
