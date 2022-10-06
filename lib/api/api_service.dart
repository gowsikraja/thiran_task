import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../utils/app_exception.dart';
import '../../utils/app_utils.dart';

class ApiService {
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      AppUtils.printLog("Api Url => $url");
      var response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      }).timeout(const Duration(minutes: 1));

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Check your Internet connection and try again.');
    } on TimeoutException {
      throw FetchDataException('Client connection timeout.');
    } on HttpException {
      throw FetchDataException('No internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 422:
        var responseJson = json.decode(response.body.toString());
        AppUtils.printLog("Api Call Response => $responseJson");
        return responseJson;
      case 400:
        AppUtils.printLog("Api Call Error => ${response.body.toString()}");
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        AppUtils.printLog("Api Call Error => ${response.body.toString()}");
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw InternalServerException('${response.statusCode}');

      default:
        AppUtils.printLog(
            "Api Call Error => Error Code : ${response.statusCode}");
        throw FetchDataException(
            'Error occurred while Communicating with Server. \n\nError Code : ${response.statusCode}');
    }
  }
}
