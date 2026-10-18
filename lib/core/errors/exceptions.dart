/// Thrown when the device has no connectivity or the host is unreachable.
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Thrown when the API returns a 5xx status code.
class ServerException implements Exception {
  final int statusCode;
  final String message;
  const ServerException(this.statusCode,
      [this.message = 'Server error. Please try again later.']);

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown when the API returns a 404 status code (e.g. page limit reached).
class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Resource not found.']);

  @override
  String toString() => 'NotFoundException: $message';
}
