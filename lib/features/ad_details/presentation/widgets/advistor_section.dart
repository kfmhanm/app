import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/login_dialog.dart';
import '../../../../shared/widgets/profile_image.dart';
import '../../domain/model/ad_details_model.dart';

class AdvisterSections extends StatelessWidget {
  const AdvisterSections(
      {super.key, required this.adDetailsModel, required this.onSucess});
  final AdDetailsModel adDetailsModel;
  final Function? onSucess;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Utils.token.isNotEmpty == true
                        ? Navigator.pushNamed(context, Routes.AdvistorScreen,
                            arguments: adDetailsModel.user?.id)
                        : Alerts.bottomSheet(
                            Utils.navigatorKey().currentContext!,
                            child: const LoginDialog(),
                            backgroundColor: Colors.white);
                  },
                  child: Row(
                    children: [
                      ProfileImage(
                        height: 25,
                        image: adDetailsModel.user?.logo,
                        color: context.primaryColor,
                      ),
                      16.pw,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            overflow: TextOverflow.ellipsis,
                            adDetailsModel.user?.name ?? '',
                            fontSize: 12,
                            weight: FontWeight.w700,
                            color: context.primaryColor,
                          ),
                          RatingBar.builder(
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            textDirection: TextDirection.ltr,
                            initialRating:
                                (adDetailsModel.user?.rate?.toString() ?? "0")
                                    .toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            // itemCount: 2,
                            itemSize: 20,
                            tapOnlyMode: true,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),

                            onRatingUpdate: (rating) {},
                            ignoreGestures: true,
                          ),
                          8.pw,
                          Row(
                            children: [
                              CustomText(
                                "( ${adDetailsModel.user?.rate.toDouble().toStringAsFixed(1)} )",
                                color: Color(0xff818181),
                              ),
                              4.pw,
                              CustomText(
                                LocaleKeys.my_ads_keys_rating.tr(),
                                color: Color(0xff818181),
                                decoration: TextDecoration.underline,
                              ),
                            ],
                          ).onTap(() {
                            Utils.token.isNotEmpty == true
                                ? () {
                                    if (Utils.userModel.id !=
                                            adDetailsModel.user?.id &&
                                        Utils.userModel.token != null)
                                      Utils.rate(
                                        context: context,
                                        userId: adDetailsModel.user?.id ?? 0,
                                        adId: adDetailsModel.id,
                                        onSucess: onSucess,
                                      );
                                  }
                                : Alerts.bottomSheet(
                                    Utils.navigatorKey().currentContext!,
                                    child: const LoginDialog(),
                                    backgroundColor: Colors.white);
                          }),
                          // Row(children: [

                          // ]),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    adDetailsModel.user?.isVerified == true
                        ? Row(
                            children: [
                              SvgPicture.asset("verified".svg()),
                              4.pw,
                              CustomText(
                                LocaleKeys.my_ads_keys_trusted_account.tr(),
                                color: context.secondaryColor,
                                weight: FontWeight.w700,
                              ),
                            ],
                          )
                        : CustomText(
                            LocaleKeys.my_ads_keys_untrusted_account.tr(),
                            color: context.secondaryColor,
                            weight: FontWeight.w700,
                          ),
                    Spacer(),
                    Row(
                      children: [
                        CustomText(
                          LocaleKeys.my_ads_keys_member_since.tr() +
                              " ${adDetailsModel.user?.createdAt ?? ""}",
                          color: LightThemeColors.textHint,
                        ),
                      ],
                    ),
                  ],
                ).paddingVertical(8)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
