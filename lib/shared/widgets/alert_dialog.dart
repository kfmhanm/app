import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/theme/light_theme.dart';
import 'package:pride/core/utils/extentions.dart';

import 'customtext.dart';

AlertDialog alertDialog(
    Color? backgroundColor,
    BuildContext context,
    AlignmentGeometry? alignment,
    Widget? icon,
    String title,
    String content,
    Function? action1,
    String action1title,
    Function action2,
    String action2title,
    Color? action2Color,
    {Widget? child}) {
  return AlertDialog(
    actionsAlignment: MainAxisAlignment.center,
    backgroundColor: backgroundColor,
    alignment: alignment,
    // icon: icon ??
    //     Icon(
    //       Icons.delete,
    //       size: 40,
    //       color: LightThemeColors.secondary,
    //     ),
    // title: CustomText(
    //   title,
    //   fontSize: 16,
    //   color: LightThemeColors.secondary,
    //   align: TextAlign.center,
    //   weight: FontWeight.w700,
    // ),
    // content: CustomText(
    //   content,
    //   color: LightThemeColors.textHint,
    //   align: TextAlign.center,
    // ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
            alignment: AlignmentDirectional.topStart,
            child: icon ??
                Icon(
                  Icons.close_outlined,
                  size: 20,
                  color: Colors.white,
                )
                    .setContainerToView(
                  padding: EdgeInsets.all(8),
                  radius: 12,
                  color: Colors.red,
                )
                    .onTap(() {
                  Navigator.pop(context);
                })),
        CustomText(
          title,
          fontSize: 16,
          color: LightThemeColors.secondary,
          align: TextAlign.center,
          weight: FontWeight.w700,
        ),
        SizedBox(height: 10),
        CustomText(
          content,
          color: LightThemeColors.textHint,
          align: TextAlign.center,
        ),
        if (child != null) ...[12.ph, child]
      ],
    ),
    actions: [
      Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          color: action2Color ?? context.secondaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                  color: action2Color ?? context.secondaryColor, width: 1)),
          child: InkWell(
            onTap: () {
              action2.call();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              child: CustomText(action2title,
                  textStyleEnum: TextStyleEnum.normal,
                  color: Colors.white,
                  weight: FontWeight.w700),
            ),
          )),
      Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: LightThemeColors.textHint, width: 1)),
          child: InkWell(
            onTap: () {
              (action1 != null) ? action1.call() : Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              child: CustomText(
                action1title,
                textStyleEnum: TextStyleEnum.normal,
                color: LightThemeColors.textHint,
                weight: FontWeight.w700,
              ),
            ),
          )),
    ],
  );
}
