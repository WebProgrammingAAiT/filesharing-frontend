part of 'resource_detail_bloc.dart';

abstract class ResourceDetailEvent extends Equatable {
  const ResourceDetailEvent();

  @override
  List<Object> get props => [];
}

class ResourceDetailInitialize extends ResourceDetailEvent {
  const ResourceDetailInitialize();
}

class GetResourceDetail extends ResourceDetailEvent {
  final String id;
  const GetResourceDetail(this.id);
}

class LikeResource extends ResourceDetailEvent {
  final String id;
  const LikeResource(this.id);
}

class UnLikeResource extends ResourceDetailEvent {
  final String id;
  const UnLikeResource(this.id);
}

class DislikeResource extends ResourceDetailEvent {
  final String id;
  const DislikeResource(this.id);
}

class UnDislikeResource extends ResourceDetailEvent {
  final String id;
  const UnDislikeResource(this.id);
}

class RemoveLikeThenDislikeResource extends ResourceDetailEvent {
  final String id;
  const RemoveLikeThenDislikeResource(this.id);
}

class RemoveDislikeThenLikeResource extends ResourceDetailEvent {
  final String id;
  const RemoveDislikeThenLikeResource(this.id);
}
