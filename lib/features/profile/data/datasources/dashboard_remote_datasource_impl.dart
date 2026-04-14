import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/token_service.dart';
import '../models/dashboard_stats_model.dart';
import '../models/activity_model.dart';
import 'dashboard_remote_datasource.dart';

/// Dashboard remote data source implementation.
///
/// Implements dashboard-related API calls using http package.
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final http.Client client;
  final TokenService tokenService;
  final String baseUrl;

  DashboardRemoteDataSourceImpl({
    required this.client,
    required this.tokenService,
    required this.baseUrl,
  });

  @override
  Future<DashboardStatsModel> getDashboard() async {
    final uri = Uri.parse('$baseUrl/v1/user/dashboard');

    // DEBUG: Print API Request
    debugPrint('🔵 GET DASHBOARD REQUEST');
    debugPrint('URL: $uri');

    final response = await client.get(
      uri,
      headers: await _buildHeaders(),
    ).timeout(
      const Duration(seconds: 30),
    );

    // DEBUG: Print API Response
    debugPrint('🟢 GET DASHBOARD RESPONSE');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      // Handle wrapped response
      if (jsonData['data'] is Map) {
        final data = jsonData['data'] as Map<String, dynamic>;
        debugPrint('✅ Successfully parsed dashboard data');
        return DashboardStatsModel.fromJson(data);
      }

      throw ServerException(message: 'Invalid data format received');
    } else if (response.statusCode == 401) {
      debugPrint('❌ Unauthorized: 401');
      throw const UnauthorizedException();
    } else if (response.statusCode == 403) {
      debugPrint('❌ Forbidden: 403');
      throw const UnauthorizedException();
    } else if (response.statusCode == 404) {
      debugPrint('❌ Not Found: 404');
      throw const NotFoundException(message: 'Dashboard not found');
    } else {
      debugPrint('❌ Server Error: ${response.statusCode}');
      throw ServerException(
        message: 'Failed to get dashboard',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<ActivityModel>> getActivity({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await client.get(
      Uri.parse(
        '$baseUrl/v1/user/activity?page=$page&limit=$limit',
      ),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final dataList = jsonData['data'] as List;
      return dataList
          .map((item) => ActivityModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException(
        message: 'Failed to get activity',
        statusCode: response.statusCode,
      );
    }
  }

  /// Build request headers with authentication.
  Future<Map<String, String>> _buildHeaders() async {
    final token = await tokenService.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
