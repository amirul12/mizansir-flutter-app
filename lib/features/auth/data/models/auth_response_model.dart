// File: lib/features/auth/data/models/auth_response_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';
import 'auth_user_model.dart';

/// Authentication response model
class AuthResponseModel extends Equatable {
  final AuthUserModel user;
  final String token;
  final String? refreshToken;

  const AuthResponseModel({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  /// Convert from JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: json['user'] is AuthUser
          ? AuthUserModel.fromEntity(json['user'] as AuthUser)
          : AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refresh_token'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
    };
  }

  @override
  List<Object?> get props => [user, token, refreshToken];
}
