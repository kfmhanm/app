// shared appBar

import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../shared/widgets/customtext.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar(
      {Key? key,
      this.titleAppBar,
      this.actions,
      this.child,
      this.leading,
      this.heroTag,
      this.sub})
      : super(key: key);
  final String? titleAppBar;
  final Widget? child;
  final Widget? leading;
  final String? sub;
  final List<Widget>? actions;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      surfaceTintColor: context.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(20.0),
            bottomRight: const Radius.circular(20.0)),
      ),
      toolbarHeight: kToolbarHeight + 20,
      backgroundColor: context.primaryColor,
      foregroundColor: context.primaryColor,
      shadowColor: context.primaryColor,
      leading: leading?.paddingDirectionalOnly(start: 16.0) ??
          (Navigator.canPop(context)
              ? BackButton(
                  color: Colors.white,
                )
              : Container()),
      title: (child != null)
          ? child
          : sub != null
              ? Column(
                  children: [
                    CustomText(titleAppBar ?? "",
                        weight: FontWeight.w800,
                        fontSize: 16.0,
                        color: Colors.white),
                    8.ph,
                    CustomText(
                      sub ?? "",
                      fontSize: 12.0,
                      color: const Color(0xff727272),
                    ),
                  ],
                )
              : CustomText(
                  titleAppBar ?? "",
                  weight: FontWeight.w700,
                  fontSize: 18.0,
                  color: Colors.white,
                ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
