import 'package:gis_disaster_flutter/api_manager/rest_client_base.dart';
import 'package:gis_disaster_flutter/config/dev_config.dart';
import 'package:dio/dio.dart';

class RestClient extends RestClientBase {
  factory RestClient() {
    _singleton ??= RestClient._internal(baseUrl: DevConfig.baseUrl);
    return _singleton!;
  }

  RestClient._internal({required super.baseUrl});

  static RestClient? _singleton;

  @override
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      dynamic data,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return mapResponse(response.data);
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<dynamic> post(String path,
      {Map<String, dynamic>? formData,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await dio.post<dynamic>(
        path,
        data: formData != null ? FormData.fromMap(formData) : data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return mapResponse(response.data);
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<dynamic> put(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return mapResponse(response.data);
    } catch (e) {
      throw mapError(e);
    }
  }

  @override
  Future<dynamic> patch(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return mapResponse(response.data);
    } catch (e) {
      throw mapError(e);
    }
  }
}
