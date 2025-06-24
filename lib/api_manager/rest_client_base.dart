import 'package:dio/dio.dart';
import 'package:gis_disaster_flutter/api_manager/api_error.dart';
import 'package:gis_disaster_flutter/api_manager/custom_interceptor.dart';

abstract class RestClientBase {
  RestClientBase({
    required this.baseUrl,
  }) {
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      // The timeout represents:
      //   - a timeout before the connection is established and the first received response bytes.
      //   - the duration during data transfer of each byte event, rather than the total duration of the receiving.
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      contentType: formUrlEncodedContentType,

      responseType: ResponseType.json,
    );

    _dio = Dio(options);
    _dio.interceptors.addAll(<Interceptor>[MainInterceptor()]);
    // _dio.interceptors.add(RefreshTokenInterceptor(_dio));
  }

  static const String formUrlEncodedContentType =
      'application/json;charset=UTF-8';
  final String baseUrl;
  late Dio _dio;

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      dynamic data,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> post(String path,
      {Map<String, dynamic>? formData,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await _dio.post<dynamic>(
        path,
        data: formData != null ? FormData.fromMap(formData) : data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> put(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<dynamic> patch(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response<dynamic> response = await _dio.patch<dynamic>(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);

      return _mapResponse(response.data);
    } catch (e) {
      throw _mapError(e);
    }
  }

  ApiError _mapError(dynamic e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiError(
            message: 'Connection timed out, please try again later.',
            extraData: e.response?.data,
          );
        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
          return ApiError(
            errorCode: '${e.response?.data['code']}',
            message: '${e.response?.data['message']}',
            extraData: e.response?.data,
          );
        case DioExceptionType.cancel:
          return ApiError(
            errorCode: '',
            message: '',
            extraData: e.response?.data,
          );
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return const ApiError(
            message: 'Network error, please try again later.',
          );
      }
    }

    return ApiError(
      errorCode: e.errorCode as String?,
      message: e.message as String?,
      extraData: e?.data,
    );
  }

  dynamic _mapResponse(dynamic response) {
    if (response is Map &&
        response['error'] != '' &&
        response['error'] != null) {
      throw ApiError(
        errorCode: response['errorCode'] as String?,
        message: response['message'] as String?,
        extraData: response,
      );
    }
    return response['data'] ?? response;
  }
}
