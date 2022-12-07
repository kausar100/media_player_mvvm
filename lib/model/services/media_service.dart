import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mvvm_flutter/model/apis/api_exception.dart';
import 'package:mvvm_flutter/model/services/base_service.dart';

import 'package:http/http.dart' as http;

class MediaService extends BaseService {
  @override
  Future getResponse(String value) async {
    dynamic responseJson;

    try {
      final response = await http.get(Uri.parse(mediaBaseUrl + value));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }


  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while communication with server with status code : ${response.statusCode}');
    }
  }
}
