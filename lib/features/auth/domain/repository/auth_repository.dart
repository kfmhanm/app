import 'dart:io';

import 'package:pride/core/utils/firebase_message.dart';
import 'package:pride/core/utils/utils.dart';
import 'package:pride/shared/widgets/myLoading.dart';

import '../../../../core/data_source/dio_helper.dart';
import '../../../../core/services/alerts.dart';
import '../request/auth_request.dart';
import 'end_points.dart';

class AuthRepository {
  final DioService dioService;
  AuthRepository(this.dioService);
  VerifyloginWithNafatRequest(String token) async {
    MyLoading.show();
   
    final response = await dioService.postData(
        url: AuthEndPoints.verifyloginWithNafatRequest,
        body: {
          "token": token,
        },
        isForm: true,
        loading: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  getNafathtoken() async {
    MyLoading.show();
    
    final response = await dioService.postData(
        url: AuthEndPoints.nafathToken,
        body: {
          "uuid": Utils.uuid,
         
        },
        isForm: true,
        loading: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }
  loginWithNafatRequest(String nationalId) async {
    MyLoading.show();
    if (Utils.FCMToken.isEmpty) {
      await FBMessging.getToken();
    }
    final response = await dioService.postData(
        url: AuthEndPoints.nafatLogin,
        body: {
          "national_id": nationalId,
          "device_type": Platform.isAndroid ? "android" : "ios",
          'device_token': Utils.FCMToken ?? "qqwqwe45234erf",
          "uuid": Utils.uuid,
        },
        isForm: true,
        loading: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  loginRequest(AuthRequest user) async {
    MyLoading.show();
    if (Utils.FCMToken.isEmpty) {
      await FBMessging.getToken();
    }

    final response = await dioService.postData(
        url: AuthEndPoints.login,
        body: user.login(),
        isForm: true,
        loading: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  registerRequest(AuthRequest user) async {
    MyLoading.show();
    if (Utils.FCMToken.isEmpty) {
      await FBMessging.getToken();
    }
    final response = await dioService.postData(
        url: AuthEndPoints.register,
        body: user.register(),
        loading: true,
        isForm: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  activate(AuthRequest user) async {
    final response = await dioService.postData(
        url: AuthEndPoints.activate,
        body: user.activate(),
        loading: true,
        isForm: true);
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  resendCodeRequest(String mobile) async {
    final response = await dioService.postData(
      url: AuthEndPoints.resendCode,
      body: {'mobile': mobile},
      isForm: true,
      loading: true,
    );
    if (response.isError == false) {
      // Alerts.snack(text: response.response?.data['message'], state: 1);
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  forgetPassRequest(String mobile) async {
    final response = await dioService.postData(
      url: AuthEndPoints.forgetPassword,
      body: {'mobile': mobile},
      isForm: true,
      loading: true,
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.success);
      return response.response?.data['data'];
    } else {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.failed);
      return null;
    }
  }

  resetPassword({
    required String code,
    required String pass,
    required String mobile,
    required String passConfirm,
  }) async {
    final response = await dioService.postData(
      url: AuthEndPoints.resetPassword,
      body: {
        'code': code,
        'password': pass,
        'mobile': mobile,
        'password_confirmation': passConfirm,
      },
      isForm: true,
      loading: true,
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.success);
      return true;
    } else {
      Alerts.snack(
          text: response.response?.data['message'], state: SnackState.failed);
      return null;
    }
  }
}
