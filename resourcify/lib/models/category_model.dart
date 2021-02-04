import 'package:dynamic_treeview/dynamic_treeview.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable implements BaseData {
  Category({
    this.id,
    this.name,
    this.parentId,
    this.extras,
  });

  final String id;
  final String name;
  final Map<String,dynamic> extras;

  final String parentId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        parentId: json["parentId"] == null ? '1' : json["parentId"],
        extras: {'key':json["_id"]}
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parentId": parentId
      };

  @override
  List<Object> get props => [id, name, parentId];

  // override for dynamic tree view
  @override
  Map<String, dynamic> getExtraData() {
    return this.extras;
  }

  @override
  String getId() {
    // TODO: implement getId
    return this.id;
  }

  @override
  String getParentId() {
    // TODO: implement getParentId
    return this.parentId;
  }

  @override
  String getTitle() {
    // TODO: implement getTitle
    return this.name;
  }
}
