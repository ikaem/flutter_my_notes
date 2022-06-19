import "package:firebase_auth/firebase_auth.dart" as FirebaseAuth show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? email;

  // const AuthUser(this.isEmailVerified);
  const AuthUser({
    required this.isEmailVerified,
    // does this need to be required if email in the class is optional
    required this.email,
  });

  factory AuthUser.fromFirebase(FirebaseAuth.User user) =>
      AuthUser(isEmailVerified: user.emailVerified, email: user.email);
}
