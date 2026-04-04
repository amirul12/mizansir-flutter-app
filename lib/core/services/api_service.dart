// File: lib/core/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

/// API Service for making HTTP requests
class ApiService {
  final http.Client client;
  final String baseUrl;

  ApiService({
    required this.baseUrl,
    http.Client? client,
  }) : client = client ?? http.Client();

  /// GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await client
          .get(
            uri,
            headers: _buildHeaders(headers),
          )
          .timeout(
            ApiConstants.connectTimeout,
            onTimeout: () => throw const TimeoutException(),
          );

      return _handleResponse(response);
    } on TimeoutException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  /// POST request
  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client
          .post(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            ApiConstants.connectTimeout,
            onTimeout: () => throw const TimeoutException(),
          );

      return _handleResponse(response);
    } on TimeoutException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  /// PUT request
  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client
          .put(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            ApiConstants.connectTimeout,
            onTimeout: () => throw const TimeoutException(),
          );

      return _handleResponse(response);
    } on TimeoutException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  /// DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final response = await client
          .delete(
            uri,
            headers: _buildHeaders(headers),
          )
          .timeout(
            ApiConstants.connectTimeout,
            onTimeout: () => throw const TimeoutException(),
          );

      return _handleResponse(response);
    } on TimeoutException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  /// Multipart POST request for file uploads
  Future<http.Response> postMultipart(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? fields,
    Map<String, http.MultipartFile>? files,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');

      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(_buildHeaders(headers))
        ..fields.addAll(fields ?? {});

      if (files != null) {
        request.files.addAll(files.values);
      }

      final http.StreamedResponse response =
          await request.send().timeout(
        ApiConstants.connectTimeout,
        onTimeout: () => throw const TimeoutException(),
      );

      final httpResponse = await http.Response.fromStream(response);
      return _handleResponse(httpResponse);
    } on TimeoutException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  /// Build headers with default values
  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }

    return headers;
  }

  /// Handle response and throw appropriate exceptions
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }

    switch (response.statusCode) {
      case 401:
        throw const UnauthorizedException();
      case 404:
        throw const NotFoundException();
      case 422:
        try {
          final errorData = jsonDecode(response.body);
          throw ValidationException(
            message: errorData['message'] ?? 'Validation failed',
            errors: errorData['errors'],
          );
        } catch (e) {
          throw const ValidationException(message: 'Validation failed');
        }
      case 500:
      case 502:
      case 503:
        throw ServerException(
          message: 'Server error occurred',
          statusCode: response.statusCode,
        );
      default:
        throw ServerException(
          message: 'Request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
        );
    }
  }
}
