import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class EditProfileRequest {
  String? name;
  String? email;
  String? phone;
  String? info;
  File? image;
  EditProfileRequest({
    this.name,
    this.email,
    this.info,
    this.phone,
    this.image,
  });

  Future<Map<String, dynamic>> toMap() async {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phone != null) {
      result.addAll({'mobile': phone});
    }
    // if (info != null) {
    //   result.addAll({'info[about]': info});
    // }
    if (image != null) {
      result.addAll({'image': await MultipartFile.fromFile(image?.path ?? "")});
    }

    return result;
  }

  // factory EditProfileRequest.fromMap(Map<String, dynamic> map) {
  //   return EditProfileRequest(
  //     name: map['name'],
  //     email: map['email'],
  //     phone: map['phone'],
  //     description: map['description'],
  //     image: map['image'] != null ? File.fromMap(map['image']) : null,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory EditProfileRequest.fromJson(String source) =>
  //     EditProfileRequest.fromMap(json.decode(source));
}
