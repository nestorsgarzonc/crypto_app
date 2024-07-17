import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Represents the response received from an API.
class ApiResponse {
  /// Creates a new instance of [ApiResponse].
  ///
  /// [response] is the raw response string received from the API.
  /// [body] is the parsed response body as a map.
  /// [statusCode] is the HTTP status code of the response.
  /// [path] is the API endpoint path.
  /// [headers] are the HTTP headers of the response.
  ApiResponse({
    required this.response,
    required this.body,
    required this.statusCode,
    required this.path,
    required this.headers,
  }) {
    log('ApiResponse: $this');
  }

  /// The API endpoint path.
  final String path;

  /// The raw response string received from the API.
  final String response;

  /// The parsed response body as a map.
  final Map<String, dynamic>? body;

  /// The HTTP status code of the response.
  final int statusCode;

  /// The HTTP headers of the response.
  final Map<String, String> headers;

  static const _decoder = JsonEncoder.withIndent('  ');

  /// Returns `true` if the response is successful (status code between 200 and 299), `false` otherwise.
  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  /// Returns `true` if the response is an error (status code outside the range of 200 to 299), `false` otherwise.
  bool get isError => !isSuccessful;

  /// Returns the parsed response body as a map.
  ///
  /// Throws an exception if the response is not a map.
  Map<String, dynamic> get responseMap {
    final body = bodyJson;
    if (body is Map<String, dynamic>) return body;
    throw Exception('Response is not a Map');
  }

  /// Returns the parsed response body as a list.
  ///
  /// Throws an exception if the response is not a list.
  List get responseList {
    final body = bodyJson;
    if (body is List<dynamic>) return body;
    throw Exception('Response is not a List');
  }

  /// Returns the HTTP headers of the response as a formatted string.
  String get headersFormatted => _decoder.convert(headers);

  /// Returns the parsed response body as a formatted string.
  String get responseFormatted => _decoder.convert(bodyJson);

  /// Returns the parsed response body as a dynamic object.
  dynamic get bodyJson => json.decode(response);

  @override
  String toString() {
    return 'ApiResponse{path: $path, response: $response, body: $body, statusCode: $statusCode, headers: $headers}';
  }

  @override
  bool operator ==(covariant ApiResponse other) {
    if (identical(this, other)) return true;

    return other.path == path &&
        other.response == response &&
        mapEquals(other.body, body) &&
        other.statusCode == statusCode &&
        mapEquals(other.headers, headers);
  }

  @override
  int get hashCode {
    return path.hashCode ^
        response.hashCode ^
        body.hashCode ^
        statusCode.hashCode ^
        headers.hashCode;
  }
}
