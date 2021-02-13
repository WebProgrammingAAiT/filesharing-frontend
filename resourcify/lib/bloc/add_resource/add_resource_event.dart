part of 'add_resource_bloc.dart';

abstract class AddResourceEvent extends Equatable {
  const AddResourceEvent();

  @override
  List<Object> get props => [];
}

class AddResourceInitialize extends AddResourceEvent {
  const AddResourceInitialize();
}

class CreateResource extends AddResourceEvent {
  final String filename;
  final String filePath;
  final String year;
  final String department;
  final String subject;
  final String fileType;
  CreateResource(this.filename, this.filePath, this.year, this.department,
      this.subject, this.fileType);
}
