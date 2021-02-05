import 'package:equatable/equatable.dart';

class Resource extends Equatable{
  String id;
  String votes;
  String resourceName;
  String uploadedBy;
  String uploadedDate;
  String fileType;
  String fileSize;
  String category;
  Resource(
      {this.id,
      this.votes,
      this.resourceName,
      this.uploadedBy,
      this.uploadedDate,
      this.fileSize,
      this.fileType,
      this.category});
  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
        id: json['_id'] as String,
        votes: json['votes'] as String,
        resourceName:json['resource_name'] as String,
        fileType:json['file_type'] as String,
        fileSize:json['file_size'] as String,
        category:json['category'] as String,
        uploadedBy: json['user_id']['user_name'] as String,
        uploadedDate: json['uploaded_date'] as String);
  }
  
  @override
  List<Object> get props =>
      [id, votes, resourceName, fileType, fileSize,uploadedBy, uploadedDate, category];
}
