// sign in exceptions
final class InvalidEmailException implements Exception {}

final class UserDisabledException implements Exception {}

final class UserNotFoundException implements Exception {}

final class WrongPasswordException implements Exception {}

final class InvalidCredentialsException implements Exception {}

// sign up exceptions
final class OperationNotAllowedException implements Exception {}

final class EmailAlreadyInUse implements Exception {}

final class WeakPassword implements Exception {}

// generic
final class GenericException implements Exception {}
