import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/Router/Router.dart';
import '../../../../../core/app_strings/locale_keys.dart';
import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/services/alerts.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/back_widget.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/customtext.dart';
import '../../../../../shared/widgets/edit_text_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is ForgetPassSuccessState) {
              Navigator.pushNamed(context, Routes.OtpScreen,
                  arguments: OtpArguments(
                    sendTo: state.phone ?? "",
                    onSubmit: (code) async {
                      if (state.code == code) {
                        Navigator.pushNamed(
                          context,
                          Routes.ResetPasswordScreen,
                          arguments: NewPasswordArgs(
                            code: state.code ?? "",
                            mobile: phoneController.text,
                          ),
                        );
                      } else {
                        Alerts.snack(
                            text: LocaleKeys.auth_otp_invalid.tr(),
                            state: SnackState.failed);
                      }
                    },
                    onReSend: () async {
                      await AuthCubit.get(context)
                          .resendCode(phoneController.text);
                    },
                    init: false,
                  ));
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
                leading: BackWidget(
                  size: 20,
                ),
                title: CustomText(
                  LocaleKeys.auth_forgot_pass.tr(),
                  fontSize: 18,
                  color: context.secondaryColor,
                  weight: FontWeight.w700,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        LocaleKeys.auth_description_otp.tr(),
                        fontSize: 14,
                        color: Colors.black,
                        weight: FontWeight.w300,
                      ),
                      40.ph,
                      SvgPicture.asset(
                        "forget_pass".svg("icons"),
                        width: 212,
                        height: 212,
                      ),
                      50.ph,
                      TextFormFieldWidget(
                        type: TextInputType.phone,
                        controller: phoneController,
                        hintText: LocaleKeys.auth_hint_phone.tr(),
                        password: false,
                        validator: (v) => Utils.valid.phoneValidation(v),
                      ),
                      30.ph,
                      ButtonWidget(
                        title: LocaleKeys.send.tr(),
                        withBorder: true,
                        buttonColor: context.primaryColor,
                        textColor: Colors.white,
                        borderColor: context.primaryColor,
                        width: double.infinity,
                        // padding: const EdgeInsets.symmetric(horizontal: 15),
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            /* final response =  */ await cubit
                                .forgetPass(phoneController.text);
                            // if (response != null) {
                            //   Navigator.pushNamed(context, Routes.OtpScreen,
                            //       arguments: OtpArguments(
                            //         sendTo: email.text,
                            //         onSubmit: (code) async {
                            //           final res = await cubit.sendCode(
                            //               email: email.text, code: code);
                            //           if (res == true) {
                            //             Navigator.pushNamed(
                            //               context,
                            //               Routes.ResetPasswordScreen,
                            //               arguments: NewPasswordArgs(
                            //                 code: cubit.codeId,
                            //                 email: email.text,
                            //               ),
                            //             );
                            //           }
                            //         },
                            //         onReSend: () async {
                            //           await cubit.resendCode(email.text);
                            //         },
                            //         init: false,
                            //       ));
                            // }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
