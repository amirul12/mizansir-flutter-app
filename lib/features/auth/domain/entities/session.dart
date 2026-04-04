// File: lib/features/auth/domain/entities/session.dart
import 'package:equatable/equatable.dart';

/// User session entity
class Session extends Equatable {
  final int id;
  final String deviceName;
  final String ipAddress;
  final DateTime lastActive;
  final bool isCurrent;

  const Session({
    required this.id,
    required this.deviceName,
    required this.ipAddress,
    required this.lastActive,
    required this.isCurrent,
  });

  @override
  List<Object?> get props => [id, deviceName, ipAddress, lastActive, isCurrent];

  /// Get formatted last active time
  String get lastActiveFormatted {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastActive.day}/${lastActive.month}/${lastActive.year}';
    }
  }

  /// Get device icon based on device name
  String get deviceIcon {
    final name = deviceName.toLowerCase();
    if (name.contains('iphone') || name.contains('ipad')) {
      return '📱';
    } else if (name.contains('android')) {
      return '📲';
    } else if (name.contains('windows') || name.contains('pc') || name.contains('laptop')) {
      return '💻';
    } else if (name.contains('mac')) {
      return '🖥️';
    } else {
      return '🔌';
    }
  }
}
