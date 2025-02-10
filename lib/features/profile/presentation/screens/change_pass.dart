import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/edit_text_widget.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key, required this.changePass});
  final Function(String oldPass, String newPass, String reNewPass) changePass;
  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  final oldPass = TextEditingController(),
      newPass = TextEditingController(),
      reNewPass = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleAppBar: LocaleKeys.change_password.tr(),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /*       30.ph,
                SvgPicture.asset(
                  "new_pass".svg(),
                  // width: 30,
                  // color: const Color(0xff9F9F9F),
                ),
                12.ph,
                SizedBox(
                  width: 120,
                  child: CustomText(
                    LocaleKeys.change_password.tr(),
                    fontSize: 12,
                    weight: FontWeight.w300,
                    align: TextAlign.center,
                  ),
                ), */
                50.ph,
                TextFormFieldWidget(
                  type: TextInputType.visiblePassword,
                  hintText: LocaleKeys.settings_current_pass.tr(),
                  password: true,
                  validator: (v) => Utils.valid.defaultValidation(v),
                  controller: oldPass,
                  borderRadius: 33,
                ),
                12.ph,
                TextButtonWidget(
                    text: LocaleKeys.auth_do_you_forget_your_password.tr(),
                    size: 16,
                    function: () {
                      Navigator.pushNamed(context, Routes.forget_passScreen);
                    }),
                20.ph,
                TextFormFieldWidget(
                  type: TextInputType.visiblePassword,
                  hintText: LocaleKeys.auth_hint_new_pass.tr(),
                  password: true,
                  validator: (v) => Utils.valid.defaultValidation(v),
                  controller: newPass,
                  borderRadius: 33,
                ),
                12.ph,
                TextFormFieldWidget(
                  type: TextInputType.visiblePassword,

                  hintText: LocaleKeys.auth_hint_confirm_pass.tr(),
                  // label: LocaleKeys.auth_email.tr(),

                  password: true,
                  validator: (v) =>
                      Utils.valid.confirmPasswordValidation(v, newPass.text),
                  controller: reNewPass,
                  borderRadius: 33,
                ),
                32.ph,
                ButtonWidget(
                    title: LocaleKeys.auth_save_pass.tr(),
                    withBorder: true,
                    buttonColor: context.primaryColor,
                    textColor: Colors.white,
                    borderColor: context.primaryColor,
                    fontSize: 16,
                    fontweight: FontWeight.bold,
                    onTap: () async {
                      FocusScope.of(context).unfocus();

                      if (formKey.currentState!.validate()) {
                        await widget.changePass(
                            oldPass.text, newPass.text, reNewPass.text);
                      }
                    }),
                32.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
