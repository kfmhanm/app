import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/extensions/widget_extensions.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/customtext.dart';

class TabTypeHome extends StatefulWidget {
  const TabTypeHome({
    super.key,
    required this.onTap,
  });
  final Function(int index)? onTap;

  @override
  State<TabTypeHome> createState() => _TabTypeHomeState();
}

class _TabTypeHomeState extends State<TabTypeHome> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      // padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      // constraints:
      //     const BoxConstraints(maxWidth: 100, minWidth: 50),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              LocaleKeys.home_keys_ads.tr(),
              color: _current == 0 ? Colors.white : LightThemeColors.textHint,
              fontSize: 16,
              weight: FontWeight.w700,
            )
                .setContainerToView(
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(16),
                    color: _current == 0 ? context.primaryColor : Colors.white)
                .onTap(() {
              setState(() {
                _current = 0;
                widget.onTap?.call(_current);
              });
            }),
          ),
          Expanded(
            child: CustomText(
              LocaleKeys.home_keys_requests.tr(),
              color: _current == 1 ? Colors.white : LightThemeColors.textHint,
              fontSize: 16,
              weight: FontWeight.w700,
            )
                .setContainerToView(
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(16),
                    color: _current == 1 ? context.primaryColor : Colors.white)
                .onTap(() {
              setState(() {
                _current = 1;
                widget.onTap?.call(_current);
              });
            }),
          ),
        ],
      ),
    );
  }
}
