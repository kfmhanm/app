import 'dart:io';

import 'package:pride/core/utils/utils.dart';

class AuthRequest {
  String? name;
  String? email;
  String? phone;
  String? code;
  String? type;
  String? createdAt;
  String? token;
  String? password;
  String? agree;
  String? fcm_token;
  String? password_confirmation;
  AuthRequest({
    this.name,
    this.email,
    this.phone,
    this.type,
    this.createdAt,
    this.fcm_token,
    this.token,
    this.password,
    this.agree,
    this.password_confirmation,
  });

  Map<String, dynamic> activate() {
    return <String, dynamic>{
      'mobile': "${phone}",
      'code': code,
      "device_type": Platform.isAndroid ? "android" : "ios",
      'device_token': Utils.FCMToken ?? "qqwqwe45234erf",
      'uuid': Utils.uuid,
    };
  }

  Map<String, dynamic> register() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'mobile': "${phone}",
      'password': password,
      'agree': agree,
      'password_confirmation': password_confirmation,
      'fcm_token': Utils.FCMToken,
      'lang': Utils.lang,
    };
  }

  Map<String, dynamic> login() {
    return <String, dynamic>{
      'device_token': Utils.FCMToken,
      "device_type": Platform.isAndroid ? "android" : "ios",
      'mobile': phone,
      'password': password,
    };
  }
}
