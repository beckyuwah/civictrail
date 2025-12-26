import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  final dio = Dio(BaseOptions(baseUrl: 'http://192.168.1.10:8000'));
  final storage = const FlutterSecureStorage();

  Api() {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        final token = await storage.read(key: 'access');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      }),
    );
  }

  Future<void> login(String u, String p) async {
    final res = await dio.post('/api/token/', data: {'username': u, 'password': p});
    await storage.write(key: 'access', value: res.data['access']);
  }

  Future<List> projects() async {
    final res = await dio.get('/api/projects/');
    return res.data;
  }
}
