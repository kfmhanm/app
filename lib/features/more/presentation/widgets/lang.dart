// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/customtext.dart';

class LangBtn extends StatelessWidget {
  const LangBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Alerts.bottomSheet(context,
            child: const LangSheet(),
            backgroundColor: context.bottomSheetBackground);
        // showModalBottomSheet(
        //     context: context,
        //     isScrollControlled: true,
        //     shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
        //     builder: (context) => const LangSheet());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // SvgPicture.asset(AppImages.langSvg),
                // Icon(
                //   Icons.language,
                //   color: context.primaryColor,
                // ),
                // 8.pw,
                CustomText(
                  'language'.tr(),
                  color: const Color(0xff3F4653),
                ),
              ],
            ),
            // const Icon(
            //   Icons.arrow_forward_ios_rounded,
            //   color: Colors.grey,
            // ),
          ],
        ),
      ),
    );
  }
}

class LangSheet extends StatefulWidget {
  const LangSheet({super.key});

  @override
  State<LangSheet> createState() => _LangSheetState();
}

class _LangSheetState extends State<LangSheet> {
  late bool isArabic;
  @override
  void initState() {
    super.initState();
    isArabic = Utils.lang == "ar";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          60.ph,
          CustomText(
            'language'.tr(),
            fontSize: 16,
            weight: FontWeight.w700,
            color: context.primaryColor,
          ),
          // 12.ph,
          // CustomText(
          //   'lang_des'.tr(),
          //   weight: FontWeight.w300,
          //   color: Colors.grey,
          // ),
          52.ph,
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  onTap: () {
                    isArabic = true;
                    setState(() {});
                  },
                  fontSize: 16,
                  height: 65,
                  withBorder: true,
                  borderColor: isArabic
                      ? context.primaryColor
                      : context.primaryColor.withOpacity(.1),
                  buttonColor: isArabic
                      ? context.primaryColor
                      : context.primaryColor.withOpacity(.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isArabic)
                        const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      CustomText(
                        'العربية (AR)',
                        fontSize: 13,
                        weight: FontWeight.w300,
                        color: isArabic ? Colors.white : context.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              12.pw,
              Expanded(
                child: ButtonWidget(
                  onTap: () {
                    isArabic = false;
                    setState(() {});
                  },
                  fontSize: 16,
                  height: 65,
                  withBorder: true,
                  buttonColor: !isArabic
                      ? context.primaryColor
                      : context.primaryColor.withOpacity(.1),
                  borderColor: !isArabic
                      ? context.primaryColor
                      : context.primaryColor.withOpacity(.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isArabic)
                        const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      CustomText(
                        'English (EN)',
                        fontSize: 13,
                        weight: FontWeight.w300,
                        color: !isArabic ? Colors.white : context.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          32.ph,
          ButtonWidget(
            onTap: () async {
              await context.setLocale(isArabic
                  ? const Locale('ar', 'EG')
                  : const Locale('en', 'US'));
              // Utils.lang = isArabic ? 'ar' : 'en';
              // Utils.hive.saveData('lng', Utils.lang);
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.splashScreen, (route) => false);
            },
            borderColor: context.primaryColor,
            width: double.infinity,
            withBorder: true,
            title: 'change_language'.tr(),
            buttonColor: context.primaryColor,
          ),
          20.ph
        ],
      ),
    );
  }
}
