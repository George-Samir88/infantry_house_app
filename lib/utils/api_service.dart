import 'package:dio/dio.dart';

class ApiService {
  Dio dio = Dio();

  Future<Response> post(
      {required String token,
        required body,
        required String url,
        Map<String, String>? headers,
        String? contentType}) async {
    return await dio.post(
      url,
      data: body,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: headers ?? {'Authorization': "Bearer $token"},
      ),
    );
  }
}