// File: lib/features/enrollment/data/models/enrollment_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/enrollment.dart';

/// Enrollment Model
class EnrollmentModel extends Equatable {
  final String id;
  final String courseId;
  final String userId;
  final String status;
  final String? paymentMethod;
  final String? paymentNotes;
  final String? transactionId;
  final double? amount;
  final DateTime enrolledAt;
  final DateTime? expiresAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EnrollmentModel({
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

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      status: json['status'] ?? 'active',
      paymentMethod: json['payment_method'],
      paymentNotes: json['payment_notes'],
      transactionId: json['transaction_id'],
      amount: json['amount'] is num ? (json['amount'] as num).toDouble() : null,
      enrolledAt: DateTime.tryParse(json['enrolled_at'] ?? '') ?? DateTime.now(),
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Enrollment toEntity() {
    return Enrollment(
      id: id,
      courseId: courseId,
      userId: userId,
      status: status,
      paymentMethod: paymentMethod,
      paymentNotes: paymentNotes,
      transactionId: transactionId,
      amount: amount,
      enrolledAt: enrolledAt,
      expiresAt: expiresAt,
      completedAt: completedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
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
