import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/Router/Router.dart';
import '../../../../../core/app_strings/locale_keys.dart';
import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/back_widget.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/customtext.dart';
import '../../../../../shared/widgets/edit_text_widget.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({Key? key, required this.code, required this.mobile})
      : super(key: key);
  final String code;
  final String mobile;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    16.ph,
                    AppBar(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leadingWidth: 80,
                      // toolbarHeight: 80,
                      leading: BackWidget(
                        size: 20,
                      ),
                      title: CustomText(
                        LocaleKeys.auth_new_password.tr(),
                        fontSize: 18,
                        color: context.secondaryColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Center(
                      child: CustomText(
                        LocaleKeys.auth_new_password_description.tr(),
                        fontSize: 14,
                        color: context.secondaryColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                    64.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormFieldWidget(
                        type: TextInputType.visiblePassword,
                        controller: passwordController,
                        hintText: LocaleKeys.auth_new_password.tr(),
                        password: true,
                        validator: Utils.valid.passwordValidation,
                      ),
                    ),
                    20.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormFieldWidget(
                        type: TextInputType.visiblePassword,
                        hintText: LocaleKeys.auth_confirm_new_pass.tr(),
                        password: true,
                        validator: (v) => Utils.valid.confirmPasswordValidation(
                            v, passwordController.text),
                        controller: confirmPasswordController,
                      ),
                    ),
                    32.ph,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ButtonWidget(
                        title: LocaleKeys.save.tr(),
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            final res = await cubit.resetPassword(
                                pass: passwordController.text.trim(),
                                mobile: widget.mobile,
                                passConfirm:
                                    confirmPasswordController.text.trim(),
                                code: widget.code);
                            if (res == true)
                              Navigator.pushNamedAndRemoveUntil(context,
                                  Routes.LoginScreen, (route) => false);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
