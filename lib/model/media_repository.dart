import 'package:mvvm_flutter/model/model.dart';
import 'package:mvvm_flutter/model/services/base_service.dart';
import 'package:mvvm_flutter/model/services/media_service.dart';

class MediaRepository {

  final BaseService _mediaService = MediaService();

  Future<List<Media>> fetchMediaList(String value) async {
    dynamic response = await _mediaService.getResponse(value);

    final jsonData = response['results'] as List;

    List<Media> mediaList =
        jsonData.map((jsonTag) => Media.fromJson(jsonTag)).toList();

    return mediaList;
  }
  
}
