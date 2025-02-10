import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../domain/model/ad_details_model.dart';

class CategoryFeaturesSection extends StatelessWidget {
  const CategoryFeaturesSection({
    super.key,
    required this.adDetailsModel,
  });

  final AdDetailsModel adDetailsModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runAlignment: WrapAlignment.start,
      // crossAxisAlignment: ,
      children: List.generate(
        adDetailsModel.categoryFeatures?.length ?? 0,
        (e) {
          final item = adDetailsModel.categoryFeatures?[e];
          return CategoryFeaturesItem(item: item).setContainerToView(
              margin: 8,
              padding: EdgeInsets.all(12),
              radius: 20,
              color: context.primaryColor.withOpacity(.02));
        },
      ),
    );
  }
}

class CategoryFeaturesItem extends StatelessWidget {
  const CategoryFeaturesItem({
    super.key,
    required this.item,
  });

  final CategoryFeatures? item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(item?.title ?? "", color: LightThemeColors.textHint),
        4.pw,
        SizedBox(
          height: 12,
          child: VerticalDivider(
            color: Color(0xffC7C7C7),
          ),
        ),
        4.pw,
        CustomText(
          item?.value ?? "",
          color: context.secondaryColor,
        ),
      ],
    );
  }
}
