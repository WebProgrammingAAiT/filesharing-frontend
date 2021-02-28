part of 'download_resource_bloc.dart';

abstract class DownloadResourceState extends Equatable {
  const DownloadResourceState();

  @override
  List<Object> get props => [];
}

class DownloadResourceInitial extends DownloadResourceState {}

class DownloadingResource extends DownloadResourceState {
  final String percent;

  DownloadingResource(this.percent);
}

class DownloadedResource extends DownloadResourceState {}

class DownloadError extends DownloadResourceState {
  final String message;

  DownloadError(this.message);

}
