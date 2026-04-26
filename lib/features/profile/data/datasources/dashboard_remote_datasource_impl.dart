import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/utils/common_json.dart';
import '../models/dashboard_stats_model.dart';
import '../models/activity_model.dart';
import 'dashboard_remote_datasource.dart';

/// Dashboard remote data source implementation using ApiMethod
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl();

  @override
  Future<DashboardStatsModel> getDashboard() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.dashboardEndpoint}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw Exception('Invalid data format');
      }

      debugPrint('✅ Successfully parsed dashboard data');
      return dashboardStatsModelFromJson(dataMap);
    } catch (e) {
      debugPrint('Error in getDashboard: $e');
      rethrow;
    }
  }

  @override
  Future<List<ActivityModel>> getActivity({
    int page = 1,
    int limit = 20,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.activityEndpoint}',
        query: {'page': page.toString(), 'limit': limit.toString()},
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final dataList = CommonToJson().getString(mapResponse);
      if (dataList == null) {
        throw Exception('Invalid data format');
      }

      return dataList
          .map((item) => ActivityModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error in getActivity: $e');
      rethrow;
    }
  }
}
