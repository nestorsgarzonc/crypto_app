import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_app/core/constants/api_constants.dart';
import 'package:crypto_app/core/failure/api_exception.dart';
import 'package:crypto_app/core/external/api_response.dart';

final apiHandlerProvider = Provider<ApiHandler>(ApiHandlerImpl.new);

abstract class ApiHandler {
  Future<ApiResponse> get(String path);
  Future<ApiResponse> delete(String path, Map<String, dynamic> body);
  Future<ApiResponse> patch(String path, Map<String, dynamic> body);
  Future<ApiResponse> post(String path, Map<String, dynamic> body);
  Future<ApiResponse> put(String path, Map<String, dynamic> body);
  Uri getUri(String path);
  List<int> processBody(Map<String, dynamic> body);
}

final class ApiHandlerImpl implements ApiHandler {
  const ApiHandlerImpl(this.ref);

  final Ref ref;

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

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

  @override
  Uri getUri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  @override
  List<int> processBody(Map<String, dynamic> body) => utf8.encode(json.encode(body));
}
