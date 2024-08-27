import 'package:dio/dio.dart';
import '../models/app-config.dart';
import 'package:get_it/get_it.dart';

class HTTPSService {
  final Dio _dio = Dio();
  AppConfig? _appConfig;
  String? Base_url;

  HTTPSService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    Base_url = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = "$Base_url$_path";
      Response _response = await _dio.get(_url);
      return _response;
    } catch (e) {
      print('HTTP Service: Unable to perform requests \n Error: $e');
    }
  }
}
