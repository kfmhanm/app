import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/model/ad_validation_model.dart';

class AdValidationRepository {
  final Dio _dio = Dio();

  Future<AdValidationResponse> validateAd({
    required String adLicenseNumber,
    required String advertiserId,
    int idType = 2,
  }) async {
    try {
      final response = await _dio.get(
        'https://api.vallo.sa/validate-ad',
        queryParameters: {
          'adLicenseNumber': adLicenseNumber,
          'advertiserId': advertiserId,
          'idType': idType,
        },
      );

      return AdValidationResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle error response
        return AdValidationResponse.fromJson(e.response!.data);
      }
      throw Exception('Failed to validate ad: ${e.message}');
    }
  }
}


