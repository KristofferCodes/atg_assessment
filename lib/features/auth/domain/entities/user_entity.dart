import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String token;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.token,
  });

  // Convenience getter — use this everywhere you need the full name
  String get fullName {
    final full = '$firstName $lastName'.trim();
    return full.isNotEmpty ? full : email;
  }

  // First name only — for greetings
  String get displayName {
    return firstName.trim().isNotEmpty ? firstName.trim() : 'Chief';
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, token];
}