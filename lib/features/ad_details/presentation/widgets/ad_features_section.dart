import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../domain/model/ad_details_model.dart';

class adFeaturesSection extends StatelessWidget {
  const adFeaturesSection({
    super.key,
    required this.adDetailsModel,
  });

  final AdDetailsModel adDetailsModel;

  @override
  Widget build(BuildContext context) {
    return adDetailsModel.adFeatures?.isNotEmpty == true
        ? Column(
            children: [
              CustomText(
                LocaleKeys.my_ads_keys_ad_details.tr(),
                color: Colors.white,
                weight: FontWeight.w700,
                fontSize: 16,
              ).setContainerToView(
                padding: EdgeInsets.all(16),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: context.primaryColor,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
              ),
              ...List.generate(adDetailsModel.adFeatures?.length ?? 0, (index) {
                final item = adDetailsModel.adFeatures?[index];
                return Container(
                  color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          item?.title ?? '',
                          color: LightThemeColors.textHint,
                        ),
                      ),
                      Row(
                        children: [
                          CustomText(
                            item?.value ?? '',
                            weight: FontWeight.w700,
                          ),
                          4.pw,
                          CustomText(
                            item?.unit ?? '',
                            color: LightThemeColors.textHint,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              20.ph
            ],
          )
        : SizedBox();
  }
}
