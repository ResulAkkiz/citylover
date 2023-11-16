import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaServices {
  static Future<List<AssetPathEntity>> loadAlbums(
      RequestType requestType) async {
    var permission = await Permission.storage.request();
    List<AssetPathEntity> albumList = [];
    if (permission.isGranted) {
      albumList = await PhotoManager.getAssetPathList(type: requestType);
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  static Future<List<AssetEntity>> loadAssets(
      AssetPathEntity selectedAlbum, int start, int end) async {
    List<AssetEntity> assetList =
        await selectedAlbum.getAssetListRange(start: start, end: end);
    await PhotoCachingManager().requestCacheAssets(
        assets: assetList,
        option: const ThumbnailOption(size: ThumbnailSize.square(50)));
    return assetList;
  }
}
