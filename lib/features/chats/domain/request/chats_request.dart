import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pride/features/home/domain/model/ads_model.dart';

class MempberShipRequest {
  final LocationModel? locationModel;
  final File? file;

  MempberShipRequest({
    this.file,
    this.locationModel,
  });

  Future<Map<String, dynamic>> toJson() async {
    return {
      "location": locationModel?.toJson(),
      'file': await MultipartFile.fromFile(file!.path),
    };
  }
}
