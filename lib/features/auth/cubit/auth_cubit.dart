import 'package:device_uuid/device_uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/utils/firebase_message.dart';
import '../../auth/domain/request/auth_request.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/utils.dart';
import '../domain/repository/auth_repository.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
 
  AuthRepository authRepository = locator<AuthRepository>();
 
  login({required AuthRequest loginRequestModel}) async {
    emit(LoginLoadingState());
    final response = await authRepository.loginRequest(loginRequestModel);

    if (response != null) {
      if (response["user"] == null) {
        emit(LoginNeedActivateState());
        return false;
      } else {
        await Utils.saveUserInHive(response);
        await FBMessging.subscripeclient();

        emit(LoginSuccessState());

        return true;
      }
    } else {
      emit(LoginErrorState());
      return null;
    }
  }

  signUp({required AuthRequest registerRequestModel}) async {
    emit(RegisterLoadingState());
    final response = await authRepository.registerRequest(registerRequestModel);
    if (response != null) {
      emit(RegisterSuccessState(
          phone: response['mobile'], code: response['code']?.toString()));
      return true;
    } else {
      emit(RegisterErrorState());
      return false;
    }
  }

  activate({required AuthRequest registerRequestModel}) async {
    Utils.uuid = await DeviceUuid().getUUID() ?? "ssssssss";
    final response = await authRepository.activate(registerRequestModel);
    if (response != null) {
      await Utils.saveUserInHive(response);
      await FBMessging.subscripeclient();
      emit(ActivateCodeSuccessState());

      return true;
    } else {
      emit(RegisterErrorState());
      return false;
    }
  }

  resendCode(String mobile) async {
    emit(ResendCodeLoadingState());
    final response = await authRepository.resendCodeRequest(mobile);

    if (response != null) {
      emit(ResendCodeSuccessState());

      return true;
    } else {
      emit(ResendCodeErrorState());
      return null;
    }
  }

  forgetPass(String mobile) async {
    emit(ForgetPassLoadingState());
    var res = await authRepository.forgetPassRequest(mobile);
    if (res != null) {
      emit(ForgetPassSuccessState(
          phone: res['mobile'], code: res['code']?.toString()));
      return true;
    } else {
      emit(ForgetPassErrorState());
      return null;
    }
  }

  resetPassword({
    required String code,
    required String pass,
    required String passConfirm,
    required String mobile,
  }) async {
    emit(ResetPasswordLoadingState());
    var res = await authRepository.resetPassword(
      code: code,
      pass: pass,
      mobile: mobile,
      passConfirm: passConfirm,
    );
    if (res != null) {
      emit(ResetPasswordSuccessState());
      return res;
    } else {
      emit(ResetPasswordErrorState());
      return null;
    }
  }
}
