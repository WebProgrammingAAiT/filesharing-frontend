import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/repository/resource_repository.dart';

part 'add_resource_event.dart';
part 'add_resource_state.dart';

class AddResourceBloc extends Bloc<AddResourceEvent, AddResourceState> {
  final ResourceRepository resourceRepository;

  AddResourceBloc(this.resourceRepository) : super(AddResourceInitial());

  @override
  Stream<AddResourceState> mapEventToState(
    AddResourceEvent event,
  ) async* {
    if (event is CreateResource) {
      try {
        yield AddResourceLoading();
        bool created = await resourceRepository.createResource(
            filename: event.filename,
            fileType: event.fileType,
            filePath: event.filePath,
            year: event.year,
            department: event.department,
            subject: event.subject);

        if (created == true) {
          yield ResourceCreated();
        } else {
          yield AddResourceError('Couldn\'t create resource');
        }
      } catch (e) {
        yield AddResourceError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is AddResourceInitialize) {
      yield AddResourceInitial();
    }
  }
}
