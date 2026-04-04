import 'package:equatable/equatable.dart';

/// Abstract base class for all profile events.
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load current user profile.
class LoadProfileEvent extends ProfileEvent {}

/// Event to update user profile.
class UpdateProfileEvent extends ProfileEvent {
  final String? name;
  final String? phone;
  final String? collegeName;
  final String? address;

  const UpdateProfileEvent({
    this.name,
    this.phone,
    this.collegeName,
    this.address,
  });

  @override
  List<Object?> get props => [name, phone, collegeName, address];
}

/// Event to upload avatar.
class UploadAvatarEvent extends ProfileEvent {
  final String imagePath;

  const UploadAvatarEvent({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// Event to change password.
class ChangePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Event to delete account.
class DeleteAccountEvent extends ProfileEvent {
  final String password;

  const DeleteAccountEvent({required this.password});

  @override
  List<Object?> get props => [password];
}

/// Event to logout.
class LogoutEvent extends ProfileEvent {}

/// Event to clear error state.
class ClearProfileErrorEvent extends ProfileEvent {}
