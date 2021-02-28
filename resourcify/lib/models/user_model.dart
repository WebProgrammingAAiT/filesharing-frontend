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
  final String year;
  final String department;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.username,
    this.role,
    this.profilePicture,
    this.year,
    this.department,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        password: json['password'] ?? '',
        role: json['role'],
        username: json['username'],
        year: json['year'] != null ? json['year']['name'] : '',
        department:
            json['department'] != null ? json['department']['name'] : '',
        profilePicture: json['profilePicture'] ?? '');
  }

  @override
  List<Object> get props =>
      [id, firstName, lastName, email, password, username, profilePicture];
}
