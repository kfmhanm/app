import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/shared/widgets/customtext.dart';

import '../../../../core/general/general_repo.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../home/domain/model/ads_model.dart';
import '../../../home/presentation/widgets/ad_Widget.dart';

class AdsBottomSheet extends StatefulWidget {
  const AdsBottomSheet({super.key, required this.ads});
  final List<AdsModel>? ads;

  @override
  State<AdsBottomSheet> createState() => _AdsBottomSheetState();
}

class _AdsBottomSheetState extends State<AdsBottomSheet> {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.224,
        controller: sheetController,
        minChildSize: 0.01,
        maxChildSize: 0.9,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            children: [
              20.ph,
              Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
              24.ph,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        LocaleKeys.swipe_up_to_view.tr() +
                            " ${widget.ads?.length ?? 0} " +
                            LocaleKeys.real_estate.tr(),
                        color: context.primaryCardColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    ButtonWidget(
                      width: 138,
                      onTap: () {
                        // sheetController.jumpTo(1);
                        sheetController.animateTo(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu, color: Colors.white),
                          8.pw,
                          CustomText(
                            LocaleKeys.view_list.tr(),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              30.ph,
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider().paddingAll(4),
                  controller: scrollController,
                  itemCount: widget.ads?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final item = widget.ads?[index];
                    print(item?.isSpecial);
                    return AdWidget(
                      adsModel: item,
                      favTap: () async {
                        item?.isFavorite = !(item.isFavorite ?? false);
                        setState(() {});
                        final res = await locator<GeneralRepo>()
                            .toggleFavorite(item?.id);
                        if (res != true) {
                          item?.isFavorite = !(item.isFavorite ?? false);
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}
