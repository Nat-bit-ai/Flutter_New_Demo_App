class UserNotFoundAuthException implements Exception {}
class WrongPasswordAuthException implements Exception {}



class WeakPasswordAuthException implements Exception {}
class EmailAlreadyInUseAuthException implements Exception {}
class InvalidEmailAuthException implements Exception {}


class GenericAuthException implements Exception {
  final String? message;
  GenericAuthException([this.message]);

  @override
  String toString() => message ?? 'Something went wrong. Please try again.';
}
class UserNotLoggedInAuthException implements Exception {}