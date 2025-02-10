import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/ad_details/domain/model/ad_details_model.dart';
import 'package:pride/features/home/domain/model/ads_model.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/general/general_repo.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/webview_payment.dart';
import '../../../home/presentation/widgets/ad_Widget.dart';
import '../../cubit/my_ads_cubit.dart';

class MyAdsTab extends StatefulWidget {
  const MyAdsTab(
      {super.key,
      required this.controller,
      required this.initPagination,
      required this.getAdDetails});
  final PagingController<int, AdsModel> controller;
  final Function initPagination;
  final Function(int adId) getAdDetails;
  @override
  State<MyAdsTab> createState() => _MyAdsTabState();
}

class _MyAdsTabState extends State<MyAdsTab>
    with AutomaticKeepAliveClientMixin {
  // late MyAdsCubit cubit;

  @override
  void initState() {
    super.initState();
    // cubit = MyAdsCubit.get(context);
    widget.initPagination();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        widget.controller.refresh();
      },
      child: PagedListView.separated(
        separatorBuilder: (context, index) => 8.ph,
        pagingController: widget.controller,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        builderDelegate: PagedChildBuilderDelegate<AdsModel>(
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Text('no_items'.tr()),
          ),
          itemBuilder: (context, item, index) {
            return SizedBox(
              height: 140,
              child: Row(
                children: [
                  Expanded(
                    child: AdWidget(
                      adsModel: item,
                      favTap: () async {
                        item.isFavorite = !(item.isFavorite ?? false);
                        setState(() {});
                        final res = await locator<GeneralRepo>()
                            .toggleFavorite(item.id);
                        if (res != true) {
                          item.isFavorite = !(item.isFavorite ?? false);
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  12.pw,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (item.isSpecial == false || item.isSpecial == null)
                        Icon(
                          Icons.star,
                          color: Color(0xffF9F9F9),
                        )
                            .setContainerToView(
                                padding: EdgeInsets.all(8),
                                radius: 12,
                                color: Color(0xffFFBD3C))
                            .onTap(() {
                          String text = "";
                          Alerts.yesOrNoDialog(context,
                              title: LocaleKeys.my_ads_keys_highlight_ad.tr(),
                              content: LocaleKeys
                                  .my_ads_keys_highlight_ad_description
                                  .tr(),
                              action1title: LocaleKeys.settings_cancel.tr(),
                              action2title:
                                  LocaleKeys.my_ads_keys_highlight.tr(),
                              child: TextFormFieldWidget(
                                type: TextInputType.number,
                                hintText:
                                    LocaleKeys.my_ads_keys_number_days.tr(),
                                password: false,
                                onChanged: (v) {
                                  text = v;
                                },
                                validator: (v) =>
                                    Utils.valid.phoneValidation(v),
                              ), action2: () async {
                            if (text.isEmpty) {
                              Alerts.snack(
                                  text: LocaleKeys.valid_requiredField.tr(),
                                  state: SnackState.failed);
                              return;
                            }
                            final res = await locator<GeneralRepo>()
                                .toggleSpecial(item.id, numberDays: text);
                            if (res != null) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WebViewPayment(url: res)),
                              );
                            }
                          }, action2Color: Color(0xffFFBD3C));
                        }),
                      SvgPicture.asset("edit".svg())
                          .setContainerToView(
                              padding: EdgeInsets.all(8),
                              radius: 12,
                              color: Color(0xffF9F9F9))
                          .onTap(() async {
                        widget.getAdDetails(item.id ?? 0);

                        //  adDetailsModel);
                      }),
                      SvgPicture.asset("delete".svg())
                          .setContainerToView(
                              padding: EdgeInsets.all(8),
                              radius: 12,
                              color: Colors.red.withOpacity(.22))
                          .onTap(() {
                        Alerts.yesOrNoDialog(context,
                            title: LocaleKeys.my_ads_keys_delete_ad.tr(),
                            content: LocaleKeys
                                .my_ads_keys_delete_ad_confirmation
                                .tr(),
                            action1title: LocaleKeys.settings_cancel.tr(),
                            action2title: LocaleKeys.my_ads_keys_delete.tr(),
                            action2: () async {
                          Navigator.pop(context);
                          final res =
                              await locator<GeneralRepo>().delete(item.id);
                          if (res == true) widget.controller.refresh();
                        }, action2Color: Colors.red);
                      }),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
