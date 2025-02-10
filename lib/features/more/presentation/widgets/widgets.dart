import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/context_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/customtext.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final Widget? child;
  final String? route;
  final Color? iconColor;
  final Color? bodyColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? weight;
  final void Function()? onTap;

  const ProfileItem({
    super.key,
    this.route,
    this.weight,
    this.fontSize,
    this.bodyColor,
    required this.title,
    this.child,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          route != null ? Navigator.pushNamed(context, route!) : onTap?.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: bodyColor ?? Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: context.primaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*    SvgPicture.asset(
              'assets/icons/$icon.svg',
              // color: iconColor ?? AppColors.primary,
            ),*/
            // 8.pw,
            CustomText(
              title.tr(),
              color: textColor ?? LightThemeColors.secondaryText,
              fontSize: fontSize,
              weight: weight,
            ),
            child != null ? child! : arrowIcon,
          ],
        ),
      ),
    );
  }
}

Icon get arrowIcon => const Icon(Icons.arrow_forward_ios, color: Colors.grey);

class TitleProfile extends StatelessWidget {
  const TitleProfile({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: context.primaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/$icon.svg',
            colorFilter:
                ColorFilter.mode(context.secondaryColor, BlendMode.srcIn),
          ),
          12.pw,
          CustomText(
            title.tr(),
            color: context.secondaryColor,
            fontSize: 14,
            weight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
