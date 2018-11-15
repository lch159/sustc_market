
import 'package:dio/dio.dart';

class DioUtil {
  Dio dio;
  Options options;
  String host ="http://120.79.232.137:8080/SUSTechFM/";

  DioUtil(String action){
    options =Options(
      baseUrl: host+action,
      connectTimeout: 10000,
      receiveTimeout: 3000,
    );
    dio =new Dio(options);
  }

}