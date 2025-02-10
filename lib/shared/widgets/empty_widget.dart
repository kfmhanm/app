import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../core/theme/light_theme.dart';
import 'customtext.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.image,
    required this.title,
    this.color,
    required this.subtitle,
    this.width,
  });
  final String image, title, subtitle;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image.svg(),
            width: width ?? 150,
            color: color,
          ),
          12.ph,
          CustomText(
            title.tr(),
            weight: FontWeight.w800,
            color: LightThemeColors.textPrimary,
          ),
          12.ph,
          if (subtitle.isNotEmpty)
            CustomText(
              subtitle.tr(),
              fontSize: 12,
              color: "B0B0B0".toColor(),
            ),
        ],
      ),
    );
  }
}
