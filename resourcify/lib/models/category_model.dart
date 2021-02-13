import 'package:equatable/equatable.dart';

class Category extends Equatable {
  Category({this.id, this.name, this.parentId, this.type});

  final String id;
  final String name;
  final String type;

  final String parentId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        parentId: json["parentId"] == null ? '1' : json["parentId"],
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "parentId": parentId, "type": type};

  @override
  List<Object> get props => [id, name, parentId, type];
}
