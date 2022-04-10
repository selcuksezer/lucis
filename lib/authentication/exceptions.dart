class PasswordIncorrectException implements Exception {
  final String? msg;

  const PasswordIncorrectException([this.msg]);

  @override
  String toString() => msg ?? 'passwordIncorrectException';
}

class UserNotFoundException implements Exception {
  final String? msg;

  const UserNotFoundException([this.msg]);

  @override
  String toString() => msg ?? 'userNotFoundException';
}

class UserAlreadyExistsException implements Exception {
  final String? msg;

  const UserAlreadyExistsException([this.msg]);

  @override
  String toString() => msg ?? 'userAlreadyExistsException';
}

class MailNotFoundException implements Exception {
  final String? msg;

  const MailNotFoundException([this.msg]);

  @override
  String toString() => msg ?? 'mailNotFoundException';
}

class MailAlreadyExistsException implements Exception {
  final String? msg;

  const MailAlreadyExistsException([this.msg]);

  @override
  String toString() => msg ?? 'mailAlreadyExistsException';
}

class MailInvalidException implements Exception {
  final String? msg;

  const MailInvalidException([this.msg]);

  @override
  String toString() => msg ?? 'mailInvalidException';
}

class WeakPasswordException implements Exception {
  final String? msg;

  const WeakPasswordException([this.msg]);

  @override
  String toString() => msg ?? 'weakPasswordException';
}

class UserDisabledException implements Exception {
  final String? msg;

  const UserDisabledException([this.msg]);

  @override
  String toString() => msg ?? 'userDisabledException';
}

class UnknownAuthException implements Exception {
  final String? msg;

  const UnknownAuthException([this.msg]);

  @override
  String toString() => msg ?? 'UnknownAuthException';
}
