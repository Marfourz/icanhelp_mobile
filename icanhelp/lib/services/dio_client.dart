import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class DioClient {
  static final Dio _dio = Dio();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Dio getInstance() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final storage = FlutterSecureStorage();
        final token = await storage.read(key: "access_token");

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },

    ));
    return _dio;
  }
}
