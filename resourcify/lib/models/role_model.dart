import 'package:equatable/equatable.dart';

class Role extends Equatable {
  final String id;
  final String name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, name];
}
