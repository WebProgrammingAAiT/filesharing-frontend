part of 'resource_bloc.dart';

class ResourceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchResources extends ResourceEvent {
  final userId;
  FetchResources(this.userId);
}

class FetchResourceDetail extends ResourceEvent {
  final resourceId;
  FetchResourceDetail(this.resourceId);
}

class ReloadResources extends ResourceEvent {
  final userId;
  ReloadResources(this.userId);
}

class CreateResource extends ResourceEvent {
  final String filename;
  final String filePath;
  final String year;
  final String department;
  final String subject;
  final String fileType;
  CreateResource(this.filename, this.filePath, this.year, this.department,
      this.subject, this.fileType);
}
