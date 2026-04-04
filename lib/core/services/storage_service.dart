// File: lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';

/// Service for managing local storage using SharedPreferences
class StorageService {
  SharedPreferences? _prefs;

  /// Initialize storage service
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      throw const CacheException(message: 'Failed to initialize storage');
    }
  }

  /// Ensure preferences are initialized
  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw const CacheException(
        message: 'StorageService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  /// Save string value
  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save string: $key');
    }
  }

  /// Get string value
  String? getString(String key) {
    try {
      return _preferences.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get string: $key');
    }
  }

  /// Save integer value
  Future<bool> setInt(String key, int value) async {
    try {
      return await _preferences.setInt(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save integer: $key');
    }
  }

  /// Get integer value
  int? getInt(String key) {
    try {
      return _preferences.getInt(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get integer: $key');
    }
  }

  /// Save boolean value
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences.setBool(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save boolean: $key');
    }
  }

  /// Get boolean value
  bool? getBool(String key) {
    try {
      return _preferences.getBool(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get boolean: $key');
    }
  }

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _preferences.setDouble(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to save double: $key');
    }
  }

  /// Get double value
  double? getDouble(String key) {
    try {
      return _preferences.getDouble(key);
    } catch (e) {
      throw CacheException(message: 'Failed to get double: $key');
    }
  }

  /// Save JSON string
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      return await _preferences.setString(key, value.toString());
    } catch (e) {
      throw CacheException(message: 'Failed to save JSON: $key');
    }
  }

  /// Remove key
  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      throw CacheException(message: 'Failed to remove key: $key');
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      throw const CacheException(message: 'Failed to clear storage');
    }
  }

  /// Check if key exists
  bool containsKey(String key) {
    try {
      return _preferences.containsKey(key);
    } catch (e) {
      throw CacheException(message: 'Failed to check key: $key');
    }
  }

  /// Get all keys
  Set<String> getKeys() {
    try {
      return _preferences.getKeys();
    } catch (e) {
      throw const CacheException(message: 'Failed to get all keys');
    }
  }
}
