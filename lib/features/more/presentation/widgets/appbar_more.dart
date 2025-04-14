import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/profile_image.dart';

class AppbarMore extends StatefulWidget implements PreferredSizeWidget {
  const AppbarMore({
    super.key,
  });

  @override
  State<AppbarMore> createState() => _AppbarMoreState();
  @override
  // TODO: implement preferredSize
  Size get preferredSize =>
      Size.fromHeight((Utils.token.isNotEmpty == true) ? 285 : 110);
}

class _AppbarMoreState extends State<AppbarMore> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        280,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(20.0),
                  bottomRight: const Radius.circular(20.0)),
            ),
          ),
          Column(
            children: [
              80.ph,
              CustomText(
                LocaleKeys.navBar_more.tr(),
                color: Colors.white,
                fontSize: 16.0,
                weight: FontWeight.w700,
              ),
              20.ph,
              if (Utils.token.isNotEmpty == true)
                Stack(
                  children: [
                    ProfileImage(
                      height: 40,
                      image: Utils.userModel.image ?? "",
                    ),
                    /*   Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                 */
                  ],
                ),
              if (Utils.token.isNotEmpty == true) Spacer(), //may make error
              //9.ph,
              if (Utils.token.isNotEmpty == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      Utils.userModel.name ?? "",
                      color: context.primaryColor,
                      fontSize: 12.0,
                      weight: FontWeight.w700,
                    ),
                    4.pw,
                    CustomText(
                      "(${(Utils.userModel.avgRate ?? "").toDouble().roundTo2numberString})",
                      color: LightThemeColors.textSecondary,
                      fontSize: 12.0,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
              if (Utils.token.isNotEmpty == true)
                IconButton(
                  onPressed: () async {
                    await Navigator.of(context).pushNamed(Routes.ProfileScreen);
                    setState(() {});
                  },
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit_outlined, color: context.primaryColor),
                      4.pw,
                      CustomText(
                        LocaleKeys.settings_edit_profile.tr(),
                        color: LightThemeColors.textSecondary,
                        fontSize: 14.0,
                        weight: FontWeight.w300,
                      ),
                    ],
                  ),
                ),
              if (Utils.token.isNotEmpty == true)
                Builder(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      "share".svg().toSvg(),
                      4.pw,
                      CustomText(
                        LocaleKeys.settings_share_account.tr(),
                        color: LightThemeColors.primary,
                        fontSize: 14.0,
                        weight: FontWeight.w300,
                      ),
                    ],
                  )
                      .setContainerToView(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          radius: 25,
                          color: context.primaryColor.withOpacity(.08))
                      .onTap(() async {
                    final box = context.findRenderObject() as RenderBox?;

                    await Share.share(
                      Utils.userModel.deep_link_url ?? "",
                      sharePositionOrigin:
                          box!.localToGlobal(Offset.zero) & box.size,
                    );
                  });
                }),
            ],
          ),
        ],
      ),
    );
  }
}
