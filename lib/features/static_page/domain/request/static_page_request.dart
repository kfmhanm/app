import 'dart:io';

class ContactUsRequest {
  String? name;
  String? email;
  String? phone;
  String? subject;
  String? message;
  File? image;
  ContactUsRequest({
    this.name,
    this.email,
    this.phone,
    this.subject,
    this.message,
    this.image,
  });

  Future<Map<String, dynamic>> toJson() async {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    // if (email != null) {
    //   result.addAll({'email': email});
    // }
    if (phone != null) {
      result.addAll({'mobile': phone});
    }
    // if (subject != null) {
    //   result.addAll({'subject': subject});
    // }
    if (message != null) {
      result.addAll({'message': message});
    }
    // if (image != null) {
    //   result.addAll({'image': MultipartFile.fromFileSync(image?.path ?? "")});
    // }

    return result;
  }

  Future<Map<String, dynamic>> complainToJson() async {
    final result = <String, dynamic>{
      'type': 'claim',
    };

    if (name != null) {
      result.addAll({'name': name});
    }
    // if (email != null) {
    //   result.addAll({'email': email});
    // }
    if (phone != null) {
      result.addAll({'mobile': phone});
    }
    // if (subject != null) {
    //   result.addAll({'subject': subject});
    // }
    if (message != null) {
      result.addAll({'message': message});
    }
    // if (image != null) {
    //   result.addAll({'image': MultipartFile.fromFileSync(image?.path ?? "")});
    // }

    return result;
  }
}
