import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gis_disaster_flutter/base/cache_manager.dart';

class MainInterceptor with CacheManager implements Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      if (err.response?.statusCode != 500) {
        debugPrint(
            '=======> [DioError][${err.response?.statusCode}][${err.response?.realUri.path}] ${err.response} <=======');
      }
    }
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('=======> ${options.method} ${options.baseUrl}${options.path}');
    options.headers.addAll(
      <String, dynamic>{'Accept': 'application/json'},
    );
    if ((getToken() ?? '').isNotEmpty) {
      debugPrint('=======> Bearer ${getToken()}');
      options.headers.addAll(
        <String, dynamic>{'Authorization': 'Bearer ${getToken()}'},
      );
    }
    debugPrint('=======> HEADER: ${options.headers}');
    if (options.data != null) {
      debugPrint('=======> [REQUEST DATA]: ${options.data}');
    } else if (options.queryParameters.isNotEmpty) {
      debugPrint(
          '=======> [REQUEST queryParameters]: ${options.queryParameters}');
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '<=== ${response.statusCode} [${response.requestOptions.method}] ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    if (response.requestOptions.data != null) {
      debugPrint('<=== [RESPONSE DATA]: ${response.requestOptions.data}');
    } else if (response.requestOptions.queryParameters.isNotEmpty) {
      debugPrint(
          '<=== [RESPONSE queryParameters]: ${response.requestOptions.queryParameters}');
    }

    if (response.data is Map || response.data is List) {
      debugPrint(jsonEncode(response.data));
    } else {
      debugPrint('${response.data}');
    }
    return handler.next(response);
  }
}
