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

/// Extension để thêm tính năng contentType linh hoạt
extension RestClientContentTypeExtension on RestClient {
  /// GET với contentType tùy chỉnh
  Future<dynamic> getWithContentType(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    dynamic data,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    String? contentType,
  }) async {
    final customOptions = options?.copyWith(contentType: contentType) ??
        Options(contentType: contentType);

    return get(
      path,
      queryParameters: queryParameters,
      options: customOptions,
      data: data,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// POST với contentType tùy chỉnh
  Future<dynamic> postWithContentType(
    String path, {
    Map<String, dynamic>? formData,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? contentType,
  }) async {
    final customOptions = options?.copyWith(contentType: contentType) ??
        Options(contentType: contentType);

    return post(
      path,
      formData: formData,
      data: data,
      queryParameters: queryParameters,
      options: customOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PUT với contentType tùy chỉnh
  Future<dynamic> putWithContentType(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? contentType,
  }) async {
    final customOptions = options?.copyWith(contentType: contentType) ??
        Options(contentType: contentType);

    return put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: customOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PATCH với contentType tùy chỉnh
  Future<dynamic> patchWithContentType(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? contentType,
  }) async {
    final customOptions = options?.copyWith(contentType: contentType) ??
        Options(contentType: contentType);

    return patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: customOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
