import 'package:flutter/foundation.dart';

/// Common utility class to parse and extract data from API responses
class CommonToJson {
  /// Extract data string from Map response
  /// Handles CommonResponseModel format with 'data' field
  static String? getString(Map<String, dynamic>? response) {
    if (response == null) return null;

    if (kDebugMode) {
      print('${response.runtimeType} : $response');
    }

    // Handle response with data field
    if (response.containsKey('data')) {
      final data = response['data'];
      if (data != null) {
        if (kDebugMode) {
          print('=-=-=-=-=-=-=- C o n t e n t -=-=-=-=-=-=');
          print(data.toString());
        }
        return data.toString();
      }
    }

    // Fallback: return entire response as string
    return response.toString();
  }

  /// Extract list data from Map response
  static List<dynamic>? getList(Map<String, dynamic>? response) {
    if (response == null) return null;

    if (response.containsKey('data') && response['data'] is List) {
      return response['data'] as List;
    }

    return null;
  }

  /// Extract map data from Map response
  static Map<String, dynamic>? getMap(Map<String, dynamic>? response) {
    if (response == null) return null;

    if (response.containsKey('data') && response['data'] is Map) {
      return response['data'] as Map<String, dynamic>;
    }

    return null;
  }
}
