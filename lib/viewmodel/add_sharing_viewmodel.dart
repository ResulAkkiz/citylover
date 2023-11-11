import 'dart:developer';

import 'package:citylover/models/usermodel.dart';
import 'package:citylover/pages/addsharing/add_sharing_page.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AddSharingViewModel extends ChangeNotifier {
  UserModel? user;
  AssetPathEntity? _selectedAlbum;
  List<AssetPathEntity> _albumList = [];
  List<AssetEntity> _assetList = [];
  List<AssetEntity> _previewAssetList = [];
  final List<AssetEntity> _selectedAssetList = [];

  List<AssetPathEntity> get albumList => _albumList;
  List<AssetEntity> get assetList => _assetList;
  List<AssetEntity> get previewAssetList => _previewAssetList;
  List<AssetEntity> get selectedAssetList => _selectedAssetList;
  AssetPathEntity? get selectedAlbum => _selectedAlbum;

  AddSharingViewModel() {
    log("AddSharingViewModel constructor executed");
    getAlbums(RequestType.common);
  }

  Future<void> getAlbums(RequestType requestType) async {
    _albumList = await MediaServices.loadAlbums(requestType);
    _selectedAlbum = albumList.first;
    await getAssetfromAlbum(0, 20);
  }

  set updateSelectedAlbum(AssetPathEntity newSelectedAlbum) {
    _selectedAlbum = newSelectedAlbum;
  }

  void updatePreviewAssetList() {
    _previewAssetList = _assetList.take(10).toList();
  }

  void removefromSelectedAsset(AssetEntity assetEntity) {
    selectedAssetList.remove(assetEntity);
    notifyListeners();
  }

  Future<void> getAssetfromAlbum(int start, int end) async {
    if (_selectedAlbum != null) {
      _assetList = await MediaServices.loadAssets(_selectedAlbum!, start, end);
      if (_previewAssetList.isEmpty) {
        updatePreviewAssetList();
      }
    }
    notifyListeners();
  }

  void selectAsset(AssetEntity asset) {
    if (_selectedAssetList.contains(asset)) {
      _selectedAssetList.remove(asset);
    } else {
      if (_selectedAssetList.length <= 4) {
        _selectedAssetList.add(asset);
      }
    }
    notifyListeners();
  }
}
