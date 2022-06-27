// lib\services\auth\firebase_auth_provider.dart
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:mynotes/firebase_options.dart' show DefaultFirebaseOptions;
import "package:mynotes/services/auth/auth_exceptions.dart";
import "package:mynotes/services/auth/auth_provider.dart";
import "package:mynotes/services/auth/auth_user.dart";

import "package:firebase_auth/firebase_auth.dart"
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> create(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user == null) throw UserNotLoggedInAuthException();
      return user;
    } on FirebaseAuthException catch (e) {
      final code = e.code;

      switch (code) {
        case "weak-password":
          throw WeakPasswordAuthException();
        case "invalid-email":
          throw InvalidEmailUserAuthException();
        case "email-already-in-user":
          throw EmailAlreadyInUseAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user == null ? null : AuthUser.fromFirebase(user);
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user == null) throw UserNotLoggedInAuthException();
      return user;
    } on FirebaseAuthException catch (e) {
      final code = e.code;

      print("code: $code");

      switch (code) {
        case "user-not-found":
          throw UserNotFoundAuthException();
        case "wrong-password":
          throw WrongPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw UserNotLoggedInAuthException();
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw UserNotLoggedInAuthException();
    await user.sendEmailVerification();
  }

  @override
  Future<void> initialize() async {
    // why not returning it?
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      final code = e.code;

      switch (code) {
        case "firebase_auth/invalid-email":
          throw InvalidEmailUserAuthException();
        case "firebase_auth/user-not-found":
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
      // if()
    } catch (e) {
      throw GenericAuthException();
    }
  }
}
