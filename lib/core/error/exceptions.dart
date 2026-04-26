class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Server error occurred'});
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'Network error occurred'});
}

class GoogleAuthException implements Exception {
  final String message;
  const GoogleAuthException(this.message);
}

class FirebaseAuthException implements Exception {
  final String message;
  const FirebaseAuthException(this.message);
}

class CancelledByUserException implements Exception {
  const CancelledByUserException();
}
