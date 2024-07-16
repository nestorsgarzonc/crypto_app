import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';

class ApiResponse {
  ApiResponse({
    required this.response,
    required this.body,
    required this.statusCode,
    required this.path,
    required this.headers,
  }) {
    log('ApiResponse: $this');
  }

  final String path;
  final String response;
  final Map<String, dynamic>? body;
  final int statusCode;
  final Map<String, String> headers;
  static const _decoder = JsonEncoder.withIndent('  ');

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
  bool get isError => !isSuccessful;

  Map<String, dynamic> get responseMap {
    final body = bodyJson;
    if (body is Map<String, dynamic>) return body;
    throw Exception('Response is not a Map');
  }

  List get responseList {
    final body = bodyJson;
    if (body is List<dynamic>) return body;
    throw Exception('Response is not a List');
  }

  String get headersFormatted => _decoder.convert(headers);
  String get responseFormatted => _decoder.convert(bodyJson);

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
