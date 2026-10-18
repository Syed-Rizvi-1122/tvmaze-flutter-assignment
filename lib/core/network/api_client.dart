import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Central HTTP client.
///
/// All API calls are routed through [get], which applies a [kApiTimeout]
/// and maps HTTP status codes to typed exceptions. JSON decoding is the
/// caller's responsibility so the client stays free of model dependencies.
class ApiClient {
  final http.Client _http;

  ApiClient({http.Client? client}) : _http = client ?? http.Client();

  /// Issues a GET request to [url] and returns the decoded body.
  ///
  /// Throws:
  ///  - [NetworkException] on [SocketException] or [TimeoutException].
  ///  - [NotFoundException] on HTTP 404.
  ///  - [ServerException] on any other non-2xx status.
  Future<dynamic> get(String url) async {
    try {
      final response = await _http
          .get(Uri.parse(url))
          .timeout(kApiTimeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw const NotFoundException();
      } else {
        throw ServerException(response.statusCode);
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Connection timed out.');
    }
  }
}
