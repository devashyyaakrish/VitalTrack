/// Failure types for error handling across layers
abstract class Failure {
  final String message;
  final String? code;
  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Requested resource not found.'});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred.'});
}
