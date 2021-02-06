import 'dart:ffi';

import 'package:equatable/equatable.dart';

class Resource extends Equatable{
  final String id;
  final String resourceName;
  final String uploadedBy;
  final String year;
  final String department;
  final String subject;
  final int likes;
  final int dislikes;
  final String fileType;
  final Float fileSize;
  final bool isLiked;
  final bool isDisliked;
  final List<String> files;
  Resource(
      {this.id,
      this.resourceName,
      this.uploadedBy,
      this.fileSize,
      this.fileType,
      this.year,
      this.department,
      this.subject,
      this.likes,
      this.dislikes,
      this.isLiked,
      this.isDisliked,
      this.files
      });
  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
        id: json['_id'] as String,
        resourceName:json['resource_name'] as String,
        fileType:json['file_type'] as String,
        fileSize:json['file_size'] as Float,
        likes: json['likes'] as int,
        dislikes: json['dislikes'] as int,
        year: json['year'],
        subject: json['subject'],
        department: json['department'],
        uploadedBy: json['created_by'],
        isLiked: json['is_liked'] as bool,
        isDisliked: json['is_disliked'] as bool,
        files: json['files'] as List<String>,

        );
  }
  
  @override
  List<Object> get props =>
      [id, resourceName, fileType, fileSize,uploadedBy, likes, dislikes, year, department, subject];
}
