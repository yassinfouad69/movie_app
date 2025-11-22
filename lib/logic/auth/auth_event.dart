import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String avatarPath;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.avatarPath,
  });

  @override
  List<Object?> get props => [name, email, password, phoneNumber, avatarPath];
}

class GoogleSignInEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdateProfileEvent extends AuthEvent {
  final String name;
  final String? phoneNumber;
  final String avatarPath;

  const UpdateProfileEvent({
    required this.name,
    this.phoneNumber,
    required this.avatarPath,
  });

  @override
  List<Object?> get props => [name, phoneNumber, avatarPath];
}

class DeleteAccountEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
