import 'package:equatable/equatable.dart';

class Category extends Equatable {
  Category({
    this.id,
    this.name,
    this.children,
    this.parentId,
  });

  final String id;
  final String name;
  final List<Category> children;
  final String parentId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        children: List<Category>.from(
            json["children"].map((x) => Category.fromJson(x))),
        parentId: json["parentId"] == null ? null : json["parentId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
        "parentId": parentId == null ? null : parentId,
      };

  @override
  List<Object> get props => [id, name, children, parentId];
}
