import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// Profile BLoC.
///
/// Manages profile-related state and operations.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadAvatarUseCase uploadAvatarUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadAvatarUseCase,
    required this.changePasswordUseCase,
    required this.deleteAccountUseCase,
    required this.logoutUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UploadAvatarEvent>(_onUploadAvatar);
    on<ChangePasswordEvent>(_onChangePassword);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<LogoutEvent>(_onLogout);
    on<ClearProfileErrorEvent>(_onClearError);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await getProfileUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(_getErrorMessage(failure))),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await updateProfileUseCase(
      UpdateProfileParams(
        name: event.name,
        phone: event.phone,
        collegeName: event.collegeName,
        address: event.address,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(_getErrorMessage(failure))),
      (profile) => emit(ProfileUpdated(profile)),
    );
  }

  Future<void> _onUploadAvatar(
    UploadAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await uploadAvatarUseCase(
      UploadAvatarParams(imagePath: event.imagePath),
    );

    result.fold(
      (failure) => emit(ProfileError(_getErrorMessage(failure))),
      (profile) => emit(AvatarUploaded(profile)),
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      ),
    );

    result.fold(
      (failure) => emit(ProfileError(_getErrorMessage(failure))),
      (_) => emit(PasswordChanged('Password changed successfully')),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await deleteAccountUseCase(
      DeleteAccountParams(password: event.password),
    );

    result.fold(
      (failure) => emit(ProfileError(_getErrorMessage(failure))),
      (_) => emit(AccountDeleted()),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(ProfileError(_getErrorMessage(failure))),
      (_) => emit(ProfileInitial()), // Will trigger navigation in UI
    );
  }

  Future<void> _onClearError(
    ClearProfileErrorEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileError) {
      emit(ProfileInitial());
    }
  }

  String _getErrorMessage(dynamic failure) {
    switch (failure.runtimeType.toString()) {
      case 'NetworkFailure':
        return 'Please check your internet connection and try again.';
      case 'UnauthorizedFailure':
        return 'You are not authorized. Please login again.';
      case 'NotFoundFailure':
        return 'Profile not found.';
      case 'ValidationFailure':
        return failure.message ?? 'Validation failed. Please check your input.';
      case 'ServerFailure':
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
