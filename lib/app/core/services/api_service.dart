// file: lib/app/core/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:spotergs/app/core/services/storage_service.dart';
import 'package:spotergs/app/utils/constants.dart';

/// Service for making HTTP requests using Dio
/// Handles authentication, error handling, and returns dynamic responses
class ApiService extends GetxService {
  late Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();

  Future<ApiService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 60000, // Increased to 60 seconds
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for authentication and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Do not attach Authorization header
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401) {
            await _storageService.clearAll();
            Get.snackbar(
              'Sessão expirada',
              'Faça login novamente',
              snackPosition: SnackPosition.BOTTOM,
            );
            Get.offAllNamed('/login');
          }
          return handler.next(error);
        },
      ),
    );

    return this;
  }

  /// GET request
  /// Returns dynamic response data (Map<String, dynamic> or List<dynamic>)
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: params,
      );
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// POST request
  /// Returns dynamic response data
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: params,
      );
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// PUT request
  /// Returns dynamic response data
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: params,
      );
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// DELETE request
  /// Returns dynamic response data
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: params,
      );
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// PATCH request
  /// Returns dynamic response data
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: params,
      );
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  /// Handle Dio errors and show user-friendly messages
  void _handleError(DioError error) {
    String message = 'Erro desconhecido';

    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      message = 'Tempo de conexão esgotado';
    } else if (error.type == DioErrorType.other) {
      message = 'Erro de conexão. Verifique sua internet';
    } else if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final responseData = error.response!.data;

      if (statusCode == 400) {
        message = responseData['message'] ?? 'Requisição inválida';
      } else if (statusCode == 404) {
        message = 'Recurso não encontrado';
      } else if (statusCode == 500) {
        message = 'Erro no servidor';
      } else {
        message = responseData['message'] ?? 'Erro ao processar requisição';
      }
    }

    Get.snackbar(
      'Erro',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
