import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String username;
  final String role;
  final String profilePicture;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.username,
      this.role,
      this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        password: json['password'] ?? '',
        role: json['role'],
        username: json['username'],
        profilePicture: json['profilePicture']);
  }

  @override
  List<Object> get props =>
      [id, firstName, lastName, email, password, username, profilePicture];
}
