// File: lib/features/auth/data/models/session_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/session.dart';

/// Session model for JSON serialization
class SessionModel extends Equatable {
  final int id;
  final String deviceName;
  final String ipAddress;
  final DateTime lastActive;
  final bool isCurrent;

  const SessionModel({
    required this.id,
    required this.deviceName,
    required this.ipAddress,
    required this.lastActive,
    required this.isCurrent,
  });

  /// Convert from JSON
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as int,
      deviceName: json['device_name'] as String,
      ipAddress: json['ip_address'] as String,
      lastActive: DateTime.parse(json['last_active'] as String),
      isCurrent: json['is_current'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_name': deviceName,
      'ip_address': ipAddress,
      'last_active': lastActive.toIso8601String(),
      'is_current': isCurrent,
    };
  }

  /// Convert to entity
  Session toEntity() {
    return Session(
      id: id,
      deviceName: deviceName,
      ipAddress: ipAddress,
      lastActive: lastActive,
      isCurrent: isCurrent,
    );
  }

  @override
  List<Object?> get props => [id, deviceName, ipAddress, lastActive, isCurrent];
}
