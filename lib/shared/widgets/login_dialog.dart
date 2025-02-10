import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/context_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../shared/widgets/button_widget.dart';
import 'customtext.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          16.ph,
          CustomText(
            "loginFirst".tr(),
            color: Colors.black,
          ),
          32.ph,
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      Routes.LoginScreen,
                    );
                  },
                  title: LocaleKeys.auth_enter.tr(),
                  withBorder: true,
                  buttonColor: context.primaryColor,
                  textColor: Colors.white,
                  borderColor: context.primaryColor,
                ),
              ),
              12.pw,
              Expanded(
                child: ButtonWidget(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      Routes.RegisterScreen,
                    );
                  },
                  title: LocaleKeys.auth_create.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
