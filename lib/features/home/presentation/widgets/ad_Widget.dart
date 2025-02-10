import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/core/utils/utils.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/login_dialog.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../domain/model/ads_model.dart';

class AdWidget extends StatelessWidget {
  const AdWidget({
    super.key,
    required this.adsModel,
    required this.favTap,
    this.isHome = false,
  });

  final AdsModel? adsModel;
  final Function()? favTap;
  final bool? isHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 140,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: NetworkImagesWidgets(
                      adsModel?.image ?? "",
                      height: 140,
                      width: 130,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: (adsModel?.status != null &&
                            (adsModel?.isSpecial == null ||
                                adsModel?.isSpecial == false))
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: adsModel?.status?.color,
                            ),
                            child: CustomText(
                              adsModel?.status?.name ?? "",
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        : (adsModel?.isSpecial != false &&
                                adsModel?.isSpecial != null)
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                ),
                                child: CustomText(
                                  LocaleKeys.home_keys_featured.tr(),
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              )
                            : null,
                  ),
                ],
              ),
              Positioned.directional(
                top: 8,
                start: 8,
                textDirection: TextDirection.ltr,
                child: InkWell(
                  onTap: () async {
                    Utils.token.isNotEmpty == true
                        ? favTap?.call()
                        : Alerts.bottomSheet(
                            Utils.navigatorKey().currentContext!,
                            child: const LoginDialog(),
                            backgroundColor: Colors.white);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: Icon(
                      adsModel?.isFavorite == true
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          adsModel?.title ?? "",
                          color: context.secondaryColor,
                          maxLine: 1,
                        ),
                      ),
                      4.pw,
                      CustomText(
                        // LocaleKeys.home_keys_since.tr() +
                        //     " " +
                        (adsModel?.createdAt ?? "").formateDate,
                        color: LightThemeColors.textHint,
                        fontSize: 12,
                        weight: FontWeight.w300,
                      ),
                    ],
                  ),
                  // 4.ph,
                  Row(
                    children: [
                      CustomText(
                        "${adsModel?.price?.toString() ?? ""} ${LocaleKeys.home_keys_riyals.tr()} ",
                        color: context.primaryColor,
                        fontSize: 12,
                        weight: FontWeight.w800,
                      ),
                      if (adsModel?.priceType != null &&
                          adsModel?.priceType?.isNotEmpty == true)
                        CustomText(
                          "/ ${adsModel?.priceType?.tr() ?? ""}",
                          color: context.primaryColor,
                          fontSize: 12,
                          weight: FontWeight.w800,
                        ),
                    ],
                  ),
                  // 4.ph,
                  Wrap(
                    children: (adsModel?.features ?? [])
                        .take(3)
                        .map(
                          (e) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NetworkImagesWidgets(
                                e.image ?? "",
                                height: 14,
                                width: 14,
                                fit: BoxFit.fill,
                              ),
                              // 4.pw,
                              // CustomText(
                              //   e.title ?? "",
                              //   color: LightThemeColors.textHint,
                              //   fontSize: 12,
                              //   weight: FontWeight.w300,
                              // ),
                              4.pw,
                              CustomText(
                                e.value ?? "",
                                color: LightThemeColors.textHint,
                                fontSize: 12,
                                weight: FontWeight.w300,
                              ),
                              4.pw,
                              CustomText(
                                e.unit ?? "",
                                color: LightThemeColors.textHint,
                                fontSize: 12,
                                weight: FontWeight.w300,
                              ),
                            ],
                          ).paddingDirectionalOnly(end: 8),
                        )
                        .toList(),
                  ),
                  // Spacer(),
                  CustomText(
                    (adsModel?.address ?? ""),
                    color: LightThemeColors.textHint,
                    fontSize: 12,
                    weight: FontWeight.w300,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).onTap(() {
      Navigator.pushNamed(context, Routes.AdDetailsScreen,
          arguments: adsModel?.id ?? 0);
    });
  }
}
