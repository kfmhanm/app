abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginErrorState extends AuthStates {}

class LoginNeedActivateState extends AuthStates {
  final String? phone;
  final String? code;
  LoginNeedActivateState({this.phone, this.code});
}

class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {
  final String? phone;
  final String? code;
  RegisterSuccessState({this.phone, this.code});
}

class RegisterErrorState extends AuthStates {}

class ResendCodeLoadingState extends AuthStates {}

class ResendCodeSuccessState extends AuthStates {}

class ResendCodeErrorState extends AuthStates {}

class ForgetPassLoadingState extends AuthStates {}

class ForgetPassSuccessState extends AuthStates {
  final String? phone;
  final String? code;
  ForgetPassSuccessState({this.phone, this.code});
}

class ForgetPassErrorState extends AuthStates {}

class ActivateCodeLoadingState extends AuthStates {}

class ActivateCodeSuccessState extends AuthStates {
  final String? phone;
  final String? code;
  ActivateCodeSuccessState({this.phone, this.code});
}

class ActivateCodeErrorState extends AuthStates {}

class ResetPasswordLoadingState extends AuthStates {}

class ResetPasswordSuccessState extends AuthStates {}

class ResetPasswordErrorState extends AuthStates {}
