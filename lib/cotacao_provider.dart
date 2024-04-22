import 'package:dio/dio.dart';

class CotacaoProvider {
  Dio dio = Dio();

  initDio() {
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<String?> getCotacaoApi(String url, String moeda) async {
    try {
      initDio();
      final response = await dio.get(url);
      return response.data['${moeda}BRL']['bid'];
    } on DioException catch (e) {
      print(e);
    }
    return null;
  }
  
}