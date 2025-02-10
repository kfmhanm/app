import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../home/presentation/widgets/ad_Widget.dart';
import '../../domain/model/ad_details_model.dart';

class SimilarAdSections extends StatelessWidget {
  const SimilarAdSections({
    super.key,
    required this.adDetailsModel,
  });

  final AdDetailsModel adDetailsModel;

  @override
  Widget build(BuildContext context) {
    if (adDetailsModel.similarAds == null || adDetailsModel.similarAds!.isEmpty)
      return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              LocaleKeys.my_ads_keys_similar_ads.tr(),
              color: context.secondaryColor,
              weight: FontWeight.w700,
            ),
            CustomText(
              LocaleKeys.home_keys_view_more.tr(),
              color: LightThemeColors.textHint,
            ).onTap(() {
              Navigator.pushNamed(context, Routes.SimilarAds,
                  arguments: adDetailsModel.id);
            }),
          ],
        ),
        12.ph,
        ...List.generate(
            adDetailsModel.similarAds?.length ?? 0,
            (e) =>
                AdWidget(adsModel: adDetailsModel.similarAds?[e], favTap: () {})
                    .paddingVertical(4))
      ],
    );
  }
}
