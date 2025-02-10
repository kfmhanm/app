import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/Router/Router.dart';
import '../../../../../core/app_strings/locale_keys.dart';
import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/theme/light_theme.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/back_widget.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/customtext.dart';
import '../../../../../shared/widgets/edit_text_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';
import '../../../domain/request/auth_request.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController password = TextEditingController();
  AuthRequest registerRequestModel = AuthRequest();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            Navigator.pushNamed(
              context,
              Routes.OtpScreen,
              arguments: OtpArguments(
                sendTo: state.phone ?? '',
                onSubmit: (s) async {
                  registerRequestModel.code = s;
                  final res = await AuthCubit.get(context).activate(
                    registerRequestModel: registerRequestModel,
                  );
                  if (res == true) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.LayoutScreen,
                      (route) => false,
                    );
                  }
                },
                onReSend: () async {
                  await AuthCubit.get(context).resendCode(
                    registerRequestModel.phone ?? '',
                  );
                },
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leadingWidth: 80,
              // toolbarHeight: 80,
              leading: BackWidget(),
              title: CustomText(
                LocaleKeys.auth_register_new_acc.tr(),
                fontSize: 18,
                color: context.secondaryColor,
                weight: FontWeight.w700,
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        LocaleKeys.auth_description_register.tr(),
                        fontSize: 14,
                        color: Colors.black,
                        weight: FontWeight.w300,
                      ),
                      40.ph,
                      Image.asset(
                        "logo".png("icons"),
                        scale: 3,
                      ),
                      50.ph,
                      TextFormFieldWidget(
                        type: TextInputType.name,
                        hintText: LocaleKeys.settings_name.tr(),
                        password: false,
                        onSaved: (e) => registerRequestModel.name = e,
                        validator: (v) => Utils.valid.defaultValidation(v),
                      ),
                      12.ph,
                      TextFormFieldWidget(
                        type: TextInputType.phone,
                        hintText: LocaleKeys.auth_hint_phone.tr(),
                        password: false,
                        onSaved: (e) => registerRequestModel.phone = e,
                        validator: (v) => Utils.valid.phoneValidation(v),
                      ),
                      12.ph,
                      TextFormFieldWidget(
                        type: TextInputType.emailAddress,
                        hintText: LocaleKeys.email.tr(),
                        password: false,
                        onSaved: (e) => registerRequestModel.email = e,
                        validator: (v) => Utils.valid.emailValidation(v),
                      ),
                      12.ph,
                      TextFormFieldWidget(
                        type: TextInputType.visiblePassword,
                        hintText: LocaleKeys.password.tr(),
                        password: true,
                        onSaved: (e) => registerRequestModel.password = e,
                        validator: Utils.valid.passwordValidation,
                        controller: password,
                      ),
                      12.ph,
                      TextFormFieldWidget(
                        type: TextInputType.visiblePassword,
                        hintText: LocaleKeys.auth_hint_password_confirm.tr(),
                        onSaved: (e) =>
                            registerRequestModel.password_confirmation = e,
                        password: true,
                        validator: (v) => Utils.valid
                            .confirmPasswordValidation(v, password.text),
                      ),
                      30.ph,
                      ButtonWidget(
                          title: LocaleKeys.auth_register_acc.tr(),
                          withBorder: true,
                          buttonColor: context.primaryColor,
                          textColor: Colors.white,
                          borderColor: context.primaryColor,
                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          onTap: () async {
                            FocusScope.of(context).unfocus();

                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              /* final response =  */ await cubit.signUp(
                                registerRequestModel: registerRequestModel,
                              );
                              // if (response == true) {}
                              // if (response['data']['active'] == true) {
                              //   // if (response['data']['type'] == 'client') {
                              //   await FBMessging.subscribeToTopic();
                              //   // }
                              //   context.pushNamedAndRemoveUntil(Routes.layout);
                              // } else if (response['data']['active'] == false) {
                              //   Navigator.pushNamed(
                              //     context,
                              //     Routes.otp,
                              //     arguments: OtpArguments(
                              //         sendTo: phone.text,
                              //         onSubmit: (s) async {
                              //           final res = await cubit.activate(
                              //               mobile: phone.text, code: s);
                              //           if (res == true) {
                              //             await FBMessging.subscribeToTopic();
                              //             context.pushNamedAndRemoveUntil(
                              //                 Routes.layout);
                              //           }
                              //         },
                              //         onReSend: () async {
                              //           await cubit.resendCode(phone.text);
                              //         },
                              //         init: false),
                              //   );
                            }
                          }),
                      12.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            LocaleKeys.auth_have_an_account.tr(),
                            fontSize: 14,
                            color: LightThemeColors.textHint,
                            weight: FontWeight.w400,
                          ),
                          TextButtonWidget(
                              text: LocaleKeys.auth_login.tr(),
                              function: () {
                                Navigator.pushReplacementNamed(
                                    context, Routes.LoginScreen);
                              }),
                        ],
                      ),
                      20.ph,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
