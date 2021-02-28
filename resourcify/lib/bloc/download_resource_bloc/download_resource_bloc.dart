import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resourcify/repository/download_resource_repository.dart';

part 'download_resource_event.dart';
part 'download_resource_state.dart';

class DownloadResourceBloc
    extends Bloc<DownloadResourceEvent, DownloadResourceState> {
  final DownloadResourceRepository downloadResourceRepository;
  DownloadResourceBloc(this.downloadResourceRepository)
      : super(DownloadResourceInitial());

  @override
  Stream<DownloadResourceState> mapEventToState(
    DownloadResourceEvent event,
  ) async* {
    if (event is IsResourceDownloaded) {
      try {
        bool isResourceDownloaded = await downloadResourceRepository
            .isResourceDownloaded(event.fileName);
        yield DownloadingResource('0.5');
        if (isResourceDownloaded) {
          yield DownloadedResource();
        } else {
          yield DownloadResourceInitial();
        }
      } catch (e) {
        print(e);
        yield DownloadError(e.toString());
      }
    }
    if (event is DownloadResource) {
      try {
        await for (var value
            in downloadResourceRepository.download(event.fileUrl)) {
          if (value == 'Download finished') {
            yield DownloadedResource();
          } else {
            yield DownloadingResource(value);
          }
        }
      } catch (e) {
        print(e);
        yield DownloadError(e.toString());
      }
    }
  }
}
