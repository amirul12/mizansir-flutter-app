import 'package:equatable/equatable.dart';
import '../../data/models/user_profile_model.dart';
 

/// Abstract base class for all profile states.
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class ProfileInitial extends ProfileState {}

/// Loading state.
class ProfileLoading extends ProfileState {}

/// Profile loaded state.
class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Profile updated state.
class ProfileUpdated extends ProfileState {
  final UserProfileModel profile;

  const ProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Avatar uploaded state.
class AvatarUploaded extends ProfileState {
  final UserProfileModel profile;

  const AvatarUploaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Password changed state.
class PasswordChanged extends ProfileState {
  final String message;

  const PasswordChanged(this.message);

  @override
  List<Object?> get props => [message];
}

/// Account deleted state.
class AccountDeleted extends ProfileState {}

/// Error state.
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
