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

    dio = Dio(options);
    dio.interceptors.addAll(<Interceptor>[MainInterceptor()]);
    // dio.interceptors.add(RefreshTokenInterceptor(dio));
  }

  static const String formUrlEncodedContentType =
      'application/x-www-form-urlencoded; charset=UTF-8';
  final String baseUrl;
  late Dio dio;

  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      dynamic data,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress});

  Future<dynamic> post(String path,
      {Map<String, dynamic>? formData,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress});

  Future<dynamic> put(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress});

  Future<dynamic> patch(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress});

  ApiError mapError(dynamic e) {
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

    if (e is ApiError) {
      return e;
    }
    // fallback cho mọi loại lỗi khác
    return ApiError(
      errorCode: null,
      message: e.toString(),
      extraData: null,
    );
  }

  dynamic mapResponse(dynamic response) {
    if (response is Map &&
        response['error'] != '' &&
        response['error'] != null) {
      throw ApiError(
        errorCode: response['errorCode'] as String?,
        message: response['message'] as String?,
        extraData: response,
      );
    }
    if (response is Map && response.containsKey('data')) {
      return response['data'];
    }
    return response;
  }
}
