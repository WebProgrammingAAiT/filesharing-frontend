import 'package:equatable/equatable.dart';
import '../../models/models.dart';
import '../../repository/resource_repository.dart';
import 'dart:async';

class ResourceEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchResources extends ResourceEvent {
  final userId;
  FetchResources(this.userId);
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}
class FetchResourceDetail extends ResourceEvent {
  final resourceId;
  FetchResourceDetail(this.resourceId);
  @override
  // TODO: implement props
  List<Object> get props => [resourceId];
}
class ReloadResources extends ResourceEvent {
  final userId;
  ReloadResources(this.userId);
  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class ResourceBloc {
  bool loading = false;
  List<Resource> resourceList = [];
  final _resourceStreamController = StreamController<List<Resource>>();
  StreamSink<List<Resource>> get _resourceSink => _resourceStreamController.sink;
  Stream<List<Resource>> get resourceStream => _resourceStreamController.stream;

  var _actionStreamController = StreamController<ResourceEvent>();
  StreamSink<ResourceEvent> get actionSink => _actionStreamController.sink;
  Stream<ResourceEvent> get _actionStream => _actionStreamController.stream;

  ResourceRepository resourceRepository;

  ResourceBloc({ResourceRepository repo}) {
    resourceRepository = repo;
    _actionStream.listen((event) async {
      
      if (event is FetchResources) {
        try {
          resourceList = await resourceRepository.getResources(event.userId);
          _resourceSink.add(resourceList);
        } on Exception catch (e) {
          _resourceSink.addError("Couldn't connect to server");
        }
      } else if (event is ReloadResources) {
        resourceList = [];
        _resourceSink.add(null);
      }
    });
  }

  void dispose() {
    _resourceStreamController.close();
    _actionStreamController.close();
  }
}
