import 'package:resourcify/data_provider/download_resource_data_provider.dart';

class DownloadResourceRepository {
  final DownloadResourceDataProvider downloadResourceDataProvider;

  const DownloadResourceRepository(this.downloadResourceDataProvider);

  download(String fileUrl) async* {
    yield* downloadResourceDataProvider.download(fileUrl);
  }

  Future<bool> isResourceDownloaded(String fileName) async {
    return await downloadResourceDataProvider.isResourceDownloaded(fileName);
  }
}
