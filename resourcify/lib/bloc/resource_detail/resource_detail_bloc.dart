import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/models/models.dart';
import 'package:resourcify/repository/resource_repository.dart';

part 'resource_detail_event.dart';
part 'resource_detail_state.dart';

class ResourceDetailBloc
    extends Bloc<ResourceDetailEvent, ResourceDetailState> {
  final ResourceRepository resourceRepository;
  ResourceDetailBloc(this.resourceRepository) : super(ResourceDetailInitial());

  @override
  Stream<ResourceDetailState> mapEventToState(
    ResourceDetailEvent event,
  ) async* {
    if (event is GetResourceDetail) {
      try {
        yield ResourceDetailLoading();
        Resource resource = await resourceRepository.getResource(event.id);
        yield ResourceDetailLoaded(resource);
      } catch (e) {
        yield ResourceDetailError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is LikeResource) {
      try {
        // yield ResourceDetailLoading();
        Resource resource =
            await resourceRepository.likeUnlikeResource(event.id, 'like');
        yield ResourceDetailLoaded(resource);
      } catch (e) {
        yield ResourceDetailError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is DislikeResource) {
      try {
        // yield ResourceDetailLoading();
        Resource resource =
            await resourceRepository.likeUnlikeResource(event.id, 'dislike');
        yield ResourceDetailLoaded(resource);
      } catch (e) {
        yield ResourceDetailError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is UnLikeResource) {
      try {
        // yield ResourceDetailLoading();
        Resource resource =
            await resourceRepository.likeUnlikeResource(event.id, 'removeLike');
        yield ResourceDetailLoaded(resource);
      } catch (e) {
        yield ResourceDetailError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is UnDislikeResource) {
      try {
        // yield ResourceDetailLoading();
        Resource resource = await resourceRepository.likeUnlikeResource(
            event.id, 'removeDislike');
        yield ResourceDetailLoaded(resource);
      } catch (e) {
        yield ResourceDetailError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is RemoveLikeThenDislikeResource) {
      try {
        // yield ResourceDetailLoading();
        Resource resource = await resourceRepository.likeUnlikeResource(
            event.id, 'removeLikeThenDislike');
        yield ResourceDetailLoaded(resource);
      } catch (e) {
        yield ResourceDetailError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is RemoveDislikeThenLikeResource) {
      try {
        // yield ResourceDetailLoading();
        Resource resource = await resourceRepository.likeUnlikeResource(
            event.id, 'removeDislikeThenLike');
        yield ResourceDetailLoaded(resource);
      } catch (e) {
        yield ResourceDetailError(e.toString() ?? 'An unknown error occured');
      }
    } else if (event is ResourceDetailInitialize) {
      yield ResourceDetailInitial();
    }
  }
}
