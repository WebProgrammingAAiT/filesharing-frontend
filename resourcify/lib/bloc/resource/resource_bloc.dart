import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import '../../repository/resource_repository.dart';
import 'dart:async';

part 'resource_event.dart';
part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final ResourceRepository resourceRepository;
  ResourceBloc(this.resourceRepository) : super(ResourceInitial());

  @override
  Stream<ResourceState> mapEventToState(ResourceEvent event) async* {
    if (event is FetchResources) {
      try {
        yield ResourceLoading();
        var resourceList = await resourceRepository.getResources(event.userId);
        var categoryList = await resourceRepository.getCategories();

        yield ResourcesLoaded(resourceList, categoryList);
      } catch (e) {
        yield ResourceError(e.toString() ?? 'An unknown error occured');
      }
    }
  }

  // bool loading = false;
  // List<Resource> resourceList = [];
  // final _resourceStreamController = StreamController<List<Resource>>();
  // StreamSink<List<Resource>> get _resourceSink => _resourceStreamController.sink;
  // Stream<List<Resource>> get resourceStream => _resourceStreamController.stream;

  // var _actionStreamController = StreamController<ResourceEvent>();
  // StreamSink<ResourceEvent> get actionSink => _actionStreamController.sink;
  // Stream<ResourceEvent> get _actionStream => _actionStreamController.stream;

  // ResourceRepository resourceRepository;

  // ResourceBloc({ResourceRepository repo}) {
  //   resourceRepository = repo;
  //   _actionStream.listen((event) async {

  //     if (event is FetchResources) {
  //       try {
  //         resourceList = await resourceRepository.getResources(event.userId);
  //         _resourceSink.add(resourceList);
  //       } on Exception catch (e) {
  //         _resourceSink.addError("Couldn't connect to server");
  //       }
  //     } else if (event is ReloadResources) {
  //       resourceList = [];
  //       _resourceSink.add(null);
  //     }
  //   });
  // }

  // void dispose() {
  //   _resourceStreamController.close();
  //   _actionStreamController.close();
  // }
}
