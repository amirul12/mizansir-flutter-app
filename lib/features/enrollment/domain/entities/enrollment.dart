// File: lib/features/enrollment/domain/entities/enrollment.dart
import 'package:equatable/equatable.dart';

/// Enrollment Entity
class Enrollment extends Equatable {
  final String id;
  final String courseId;
  final String userId;
  final String status; // active, pending, completed, expired, cancelled
  final String? paymentMethod;
  final String? paymentNotes;
  final String? transactionId;
  final double? amount;
  final DateTime enrolledAt;
  final DateTime? expiresAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Enrollment({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.status,
    this.paymentMethod,
    this.paymentNotes,
    this.transactionId,
    this.amount,
    required this.enrolledAt,
    this.expiresAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getters
  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isExpired => status == 'expired';
  bool get isCancelled => status == 'cancelled';
  bool get isPaid => amount != null && amount! > 0;
  bool get hasExpiryDate => expiresAt != null;

  String get statusLabel {
    switch (status) {
      case 'active':
        return 'Active';
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'expired':
        return 'Expired';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  bool get isExpiredNow {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  int get daysUntilExpiry {
    if (expiresAt == null) return -1;
    return expiresAt!.difference(DateTime.now()).inDays;
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        userId,
        status,
        paymentMethod,
        paymentNotes,
        transactionId,
        amount,
        enrolledAt,
        expiresAt,
        completedAt,
        createdAt,
        updatedAt,
      ];
}
