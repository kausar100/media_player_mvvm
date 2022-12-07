import 'package:flutter/cupertino.dart';
import 'package:mvvm_flutter/model/apis/api_responses.dart';
import 'package:mvvm_flutter/model/media_repository.dart';
import 'package:mvvm_flutter/model/model.dart';

class MediaViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  Media? _media;

  ApiResponse get response => _apiResponse;

  Media? get media => _media;

  Future<void> fetchMediaData(String url) async {
    _apiResponse = ApiResponse.loading('Fetching artist data...');
    notifyListeners();

    try {
      List<Media> mediaList = await MediaRepository().fetchMediaList(url);
      _apiResponse = ApiResponse.completed(mediaList);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  void setSelectedMedia(Media? media) {
    _media = media;
    notifyListeners();
  }
}
