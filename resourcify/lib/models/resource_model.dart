import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';

class Resource extends Equatable {
  final String id;
  final String resourceName;
  final User uploadedBy;
  final String year;
  final String department;
  final String subject;
  final int likes;
  final int dislikes;
  final String fileType;
  final double fileSize;
  final bool isLiked;
  final bool isDisliked;
  final List<String> files;
  final String createdAt;
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
      this.createdAt,
      this.files});
  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
        id: json['_id'],
        resourceName: json['name'],
        fileType: json['fileType'],
        fileSize: json['fileSize'].toDouble(),
        likes: json['likes'],
        dislikes: json['dislikes'],
        year: json['year']['name'],
        subject: json['subject']['name'],
        department: json['department']['name'],
        uploadedBy: User.fromJson(json['createdBy']),
        createdAt: json['createdAt'],
        isLiked: json['isLiked'] ?? false,
        isDisliked: json['isDisliked'] ?? false,
        files: List<String>.from(json["files"].map((x) => x["name"])));
  }

  @override
  List<Object> get props => [
        id,
        resourceName,
        fileType,
        fileSize,
        uploadedBy,
        likes,
        dislikes,
        year,
        department,
        subject,
        createdAt,
        files,
        isLiked,
        isDisliked
      ];
}
