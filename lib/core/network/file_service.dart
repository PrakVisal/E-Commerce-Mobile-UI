import 'package:dio/dio.dart';
import 'package:flutter_products_app/core/network/dio_client.dart';
import 'package:image_picker/image_picker.dart';

class FileService {
  final Dio _dio = DioClient.dio;

  static const String _previewPath = '/api/v1/files/preview-file/';

  static String getImageUrl(String rawValue) {
    if (rawValue.isEmpty) return '';

    // Extract filename if the stored value is already a full preview-file URL
    String fileName = rawValue;
    final previewIndex = rawValue.indexOf(_previewPath);
    if (previewIndex != -1) {
      fileName = rawValue.substring(previewIndex + _previewPath.length);
    }

    // If it's still an arbitrary http URL (not a preview-file one), return as-is
    if (fileName.startsWith('http://') || fileName.startsWith('https://')) {
      return fileName;
    }

    return '${DioClient.dio.options.baseUrl}$_previewPath$fileName';
  }

  Future<String> uploadFile(XFile file) async {
    try {
      String fileName = file.name;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromBytes(
          await file.readAsBytes(),
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        '/api/v1/files/upload-file',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final data =
          response.data['payload'] ?? response.data['data'] ?? response.data;
      if (data != null && data['fileUrl'] != null) {
        String fullUrl = data['fileUrl'];
        return fullUrl.split('/').last;
      }

      throw Exception("Invalid response format. Missing fileUrl.");
    } on DioException catch (e) {
      throw Exception(
          "File upload failed: ${e.response?.data['message'] ?? e.message}");
    }
  }
}
