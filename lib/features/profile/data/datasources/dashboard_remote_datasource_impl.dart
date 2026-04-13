import 'dart:convert';
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
    final response = await client.get(
      Uri.parse('$baseUrl/v1/dashboard'),
      headers: await _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'] as Map<String, dynamic>;
      return DashboardStatsModel.fromJson(data);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
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
