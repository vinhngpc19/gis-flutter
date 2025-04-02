import 'package:dio/dio.dart';
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
      throw e;
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
      throw e;
    }
  }

  // ApiError _mapError(dynamic e) {
  //   if (e is DioException) {
  //     // String? code = e.response?.statusCode.toString();
  //     switch (e.type) {
  //       case DioExceptionType.connectionTimeout:
  //       case DioExceptionType.sendTimeout:
  //       case DioExceptionType.receiveTimeout:
  //         return ApiError(
  //           message: LocaleKeys.unexpectedError,
  //           extraData: e.response?.data,
  //         );
  //       case DioExceptionType.badCertificate:
  //       case DioExceptionType.badResponse:
  //         return ApiError(
  //           errorCode: '${e.response?.data['code']}',
  //           message: '${e.response?.data['message']}',
  //           extraData: e.response?.data,
  //         );
  //       case DioExceptionType.cancel:
  //         return ApiError(
  //           errorCode: '',
  //           message: '',
  //           extraData: e.response?.data,
  //         );
  //       case DioExceptionType.connectionError:
  //       case DioExceptionType.unknown:
  //         return const ApiError(
  //           message: LocaleKeys.noInternet,
  //         );
  //     }
  //   }

  //   if (e is ApiError) {
  //     return ApiError(errorCode: e.errorCode, message: '${e.message}');
  //   }

  //   return ApiError(
  //     errorCode: '${e.errorCode}',
  //     message: '${e.message}',
  //     extraData: e?.data,
  //   );
  // }

  dynamic _mapResponse(dynamic response) {
    // if (response is Map &&
    //     ((response['success'] ?? response['Success']) as bool == false)) {
    //   throw ApiError(
    //       errorCode: '${(response['success'] ?? response['Success']) as bool?}',
    //       message: response['message'] as String?);
    // }
    if (response is Map &&
        response['error'] != '' &&
        response['error'] != null) {
      // throw ApiError(
      //   // error: response['error'] as String?,
      //   message: response['message'] as String?,
      //   extraData: response,
      // );
    }
    return response['data'] ?? response;
  }
}

class Errors {
  Errors({
    required this.message,
    this.extensions,
  });

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        message: json['message'],
        extensions: json['extensions'] == null
            ? null
            : Extensions.fromJson(json['extensions']),
      );
  String? message;
  Extensions? extensions;
}

class Extensions {
  Extensions({
    this.code,
  });
  factory Extensions.fromJson(Map<String, dynamic> json) => Extensions(
        code: json['code'],
      );
  dynamic code;
}
