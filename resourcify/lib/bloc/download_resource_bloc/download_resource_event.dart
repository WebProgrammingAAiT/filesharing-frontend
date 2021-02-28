part of 'download_resource_bloc.dart';

abstract class DownloadResourceEvent extends Equatable {
  const DownloadResourceEvent();

  @override
  List<Object> get props => [];
}

class IsResourceDownloaded extends DownloadResourceEvent {
  final String fileName;

  IsResourceDownloaded(this.fileName);
}

class DownloadResource extends DownloadResourceEvent {
  final String fileUrl;

  DownloadResource(this.fileUrl);
}
