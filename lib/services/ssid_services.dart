import 'package:dio/dio.dart';

class SSIDService {
  Dio _dio;

  SSIDService(Dio dio) {
    _dio = dio;
  }

  Future<dynamic> submitData(
      Map<String, dynamic> body) async {
    try {
      Response response = await _dio.post(
          _dio.options.baseUrl + '/cluster',
          data: body);
      dynamic apiResponse = response.data;
      if (apiResponse != null) {
        return apiResponse;
      } else {
        throw Exception('HTTP Response Error');
      }
    } catch (error) {
      print("error");
      print(error);
    }
  }
}