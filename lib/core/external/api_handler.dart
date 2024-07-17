import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_app/core/constants/api_constants.dart';
import 'package:crypto_app/core/failure/api_exception.dart';
import 'package:crypto_app/core/external/api_response.dart';

/// A provider for the [ApiHandler] implementation.
final apiHandlerProvider = Provider<ApiHandler>(ApiHandlerImpl.new);

/// An abstract class that defines the contract for an API handler.
abstract class ApiHandler {
  /// Sends a GET request to the specified [path] and returns the [ApiResponse].
  Future<ApiResponse> get(String path);

  /// Sends a DELETE request to the specified [path] with the given [body] and returns the [ApiResponse].
  Future<ApiResponse> delete(String path, Map<String, dynamic> body);

  /// Sends a PATCH request to the specified [path] with the given [body] and returns the [ApiResponse].
  Future<ApiResponse> patch(String path, Map<String, dynamic> body);

  /// Sends a POST request to the specified [path] with the given [body] and returns the [ApiResponse].
  Future<ApiResponse> post(String path, Map<String, dynamic> body);

  /// Sends a PUT request to the specified [path] with the given [body] and returns the [ApiResponse].
  Future<ApiResponse> put(String path, Map<String, dynamic> body);

  /// Returns the [Uri] for the specified [path].
  Uri getUri(String path);

  /// Processes the [body] and returns it as a list of integers.
  List<int> processBody(Map<String, dynamic> body);
}

/// An implementation of the [ApiHandler] interface.
/// Implementation of the [ApiHandler] interface.
class ApiHandlerImpl implements ApiHandler {
  const ApiHandlerImpl(this.ref);

  final Ref ref;

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'x-cg-demo-api-key': ApiConstants.apiKey,
  };

  /// Sends a DELETE request to the specified [path] with the given [body].
  /// Returns a [Future] that completes with the [ApiResponse].
  /// Throws an [ApiException] if the response indicates an error.
  @override
  Future<ApiResponse> delete(String path, Map<String, dynamic> body) async {
    final res = await http.delete(getUri(path), headers: _headers, body: processBody(body));
    final apiResponse = ApiResponse(
      path: path,
      body: null,
      response: res.body,
      statusCode: res.statusCode,
      headers: _headers,
    );
    if (apiResponse.isError) throw ApiException(apiResponse);
    return apiResponse;
  }

  /// Sends a GET request to the specified [path].
  /// Returns a [Future] that completes with the [ApiResponse].
  /// Throws an [ApiException] if the response indicates an error.
  @override
  Future<ApiResponse> get(String path) async {
    final res = await http.get(getUri(path), headers: _headers);
    final apiResponse = ApiResponse(
      path: path,
      body: null,
      response: res.body,
      statusCode: res.statusCode,
      headers: _headers,
    );
    if (apiResponse.isError) throw ApiException(apiResponse);
    return apiResponse;
  }

  /// Sends a PATCH request to the specified [path] with the given [body].
  /// Returns a [Future] that completes with the [ApiResponse].
  /// Throws an [ApiException] if the response indicates an error.
  @override
  Future<ApiResponse> patch(String path, Map<String, dynamic> body) async {
    final res = await http.patch(getUri(path), headers: _headers, body: processBody(body));
    final apiResponse = ApiResponse(
      path: path,
      body: body,
      response: res.body,
      statusCode: res.statusCode,
      headers: _headers,
    );
    if (apiResponse.isError) throw ApiException(apiResponse);
    return apiResponse;
  }

  /// Sends a POST request to the specified [path] with the given [body].
  /// Returns a [Future] that completes with the [ApiResponse].
  /// Throws an [ApiException] if the response indicates an error.
  @override
  Future<ApiResponse> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(getUri(path), headers: _headers, body: processBody(body)).timeout(
          const Duration(seconds: 30),
        );
    final apiResponse = ApiResponse(
      path: path,
      body: body,
      response: res.body,
      statusCode: res.statusCode,
      headers: _headers,
    );
    if (apiResponse.isError) throw ApiException(apiResponse);
    return apiResponse;
  }

  /// Sends a PUT request to the specified [path] with the given [body].
  /// Returns a [Future] that completes with the [ApiResponse].
  /// Throws an [ApiException] if the response indicates an error.
  @override
  Future<ApiResponse> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(getUri(path), headers: _headers, body: processBody(body));
    final apiResponse = ApiResponse(
      path: path,
      body: body,
      response: res.body,
      statusCode: res.statusCode,
      headers: _headers,
    );
    if (apiResponse.isError) throw ApiException(apiResponse);
    return apiResponse;
  }

  /// Returns the [Uri] for the specified [path] by combining it with the base URL.
  @override
  Uri getUri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  /// Processes the [body] by encoding it as JSON and converting it to a list of bytes.
  @override
  List<int> processBody(Map<String, dynamic> body) => utf8.encode(json.encode(body));
}
