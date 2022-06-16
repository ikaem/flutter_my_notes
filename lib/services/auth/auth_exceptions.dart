// lib\services\auth\auth_exceptions.dart
// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailUserAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

// this is for when user is not logged in after registering
class UserNotLoggedInAuthException implements Exception {}
