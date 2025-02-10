import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

// import '../../../../core/Router/Router.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
// import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/utils.dart';
// import '../../../../shared/widgets/button_widget.dart';
// import '../../../../shared/widgets/customtext.dart';
// import '../../cubit/more_cubit.dart';
import '../../cubit/more_cubit.dart';
import 'widgets.dart';

class DeleteAccBtn extends StatelessWidget {
  const DeleteAccBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileItem(
      title: LocaleKeys.delete_account,
      bodyColor: const Color(0xffFFD2D2),
      textColor: const Color(0xff121212),
      child: 0.pw,
      onTap: () {
        Alerts.yesOrNoDialog(
          context,
          title: LocaleKeys.delete_account.tr(),
          content: LocaleKeys.settings_confirm_delete_account.tr(),
          action2title: LocaleKeys.my_ads_keys_delete.tr(),
          action1title: LocaleKeys.no.tr(),
          action1: () => Navigator.of(context).pop(),
          action2Color: const Color(0xffFF0000),
          action2: () async {
            final res = await context.read<MoreCubit>().deleteAccount();
            if (res == true) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.LoginScreen, (Route<dynamic> route) => false);
            }
          },
          /*    child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.ph,
                CustomText(
                  LocaleKeys.delete_account.tr(),
                  fontSize: 16,
                  weight: FontWeight.w700,
                  color: LightThemeColors.primaryText,
                ),
                12.ph,
                CustomText(
                  LocaleKeys.delete_accoun_sure.tr(),
                  color: LightThemeColors.textSecondary,
                  align: TextAlign.center,
                  weight: FontWeight.w300,
                ),
                40.ph,
                ButtonWidget(
                    width: 250,
                    fontweight: FontWeight.bold,
                    buttonColor: const Color(0xffE90B0B),
                    onTap: () async {
                      final res =
                          await context.read<MoreCubit>().deleteAccount();
                      if (res == true) {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.LoginScreen,
                            (Route<dynamic> route) => false);
                      }
                    },
                    title: LocaleKeys.delete_account.tr()),
                20.ph,
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomText("cancel".tr()),
                ),
                32.ph,
              ],
            ),
          ),
         */
        );
      },
    );
  }
}

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileItem(
      title: LocaleKeys.logout,
      textColor: const Color(0xffffffff),
      fontSize: 16,
      weight: FontWeight.w700,
      child: Icon(
        Icons.logout,
        color: const Color(0xffffffff),
      ),
      bodyColor: const Color(0xffFF0000),
      onTap: () {
        Alerts.yesOrNoDialog(
          context,
          title: LocaleKeys.logout.tr(),
          content: LocaleKeys.settings_confirm_logout.tr(),
          action2title: LocaleKeys.logout.tr(),
          action1title: LocaleKeys.no.tr(),
          // action1: () => Navigator.of(context).pop(),
          action2Color: const Color(0xffFF0000),
          action2: () async {
            Utils.logout();
          },
        );
      },
    );
  }
}
