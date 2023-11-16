import 'dart:developer';

import 'package:citylover/app_contants/media_services.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AddSharingViewModel extends ChangeNotifier {
  AssetPathEntity? _selectedAlbum;
  List<AssetPathEntity> _albumList = [];
  final List<AssetEntity> _assetList = [];
  List<AssetEntity> _previewAssetList = [];
  final List<AssetEntity> _selectedAssetList = [];
  String contentText = "";
  int _assetCount = 0;

  List<AssetPathEntity> get albumList => _albumList;
  List<AssetEntity> get assetList => _assetList;
  List<AssetEntity> get previewAssetList => _previewAssetList;
  List<AssetEntity> get selectedAssetList => _selectedAssetList;
  AssetPathEntity? get selectedAlbum => _selectedAlbum;
  bool get loadMore => startIndex < _assetCount;

  int interval = 10;
  int startIndex = 0;
  late int endIndex = startIndex + interval;

  AddSharingViewModel() {
    log("AddSharingViewModel constructor executed");
    getAlbums(RequestType.common);
  }

  Future<void> getAlbums(RequestType requestType) async {
    _albumList = await MediaServices.loadAlbums(requestType);
    _selectedAlbum = albumList.first;
    await getAssetfromAlbum();
  }

  set updateSelectedAlbum(AssetPathEntity newSelectedAlbum) {
    if (_selectedAlbum != newSelectedAlbum) {
      _selectedAlbum = newSelectedAlbum;
      _assetList.clear();
      resetIndexValues();
    }
  }

  void updatePreviewAssetList() {
    _previewAssetList = _assetList.take(10).toList();
  }

  void insertImagetoPreviewList(AssetEntity assetEntity) {
    log("_preview list lengt: ${_previewAssetList.length}");
    _previewAssetList.insert(0, assetEntity);
    log("_preview list lengt: ${_previewAssetList.length}");
    notifyListeners();
  }

  void removefromSelectedAsset(AssetEntity assetEntity) {
    selectedAssetList.remove(assetEntity);
    notifyListeners();
  }

  void resetIndexValues() {
    _assetCount = 0;
    interval = 10;
    startIndex = 0;
    endIndex = startIndex + interval;
  }

  Future<void> getAssetfromAlbum() async {
    if (_selectedAlbum != null) {
      _assetCount = await _selectedAlbum!.assetCountAsync;
      List<AssetEntity> currentAssetList = await MediaServices.loadAssets(
          _selectedAlbum!, startIndex, startIndex + interval);
      _assetList.addAll(currentAssetList);
      if (_previewAssetList.isEmpty) {
        updatePreviewAssetList();
      }
      if (loadMore) {
        startIndex = startIndex + interval;
        endIndex = startIndex + interval;
      }
    }

    notifyListeners();
  }

  void selectAsset(AssetEntity asset) {
    if (_selectedAssetList.contains(asset)) {
      _selectedAssetList.remove(asset);
      notifyListeners();
    } else {
      if (_selectedAssetList.length <= 4) {
        _selectedAssetList.add(asset);
        notifyListeners();
      }
    }
  }
}
