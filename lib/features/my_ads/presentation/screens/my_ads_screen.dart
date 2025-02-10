import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import '../../../../core/Router/Router.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../home/presentation/widgets/widgets.dart';
import '../../cubit/my_ads_cubit.dart';
import '../../cubit/my_ads_states.dart';
import '../widgets/my_ads_tab.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({Key? key}) : super(key: key);

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyAdsCubit()..initTabController(this),
      child: BlocConsumer<MyAdsCubit, MyAdsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = MyAdsCubit.get(context);
          return Scaffold(
            appBar: DefaultAppBar(
              titleAppBar: LocaleKeys.navBar_my_ads.tr(),
              /*        actions: [
                if (cubit.myAdscontroller.itemList?.isNotEmpty == true)
                  SvgPicture.asset("delete".svg())
                      .setContainerToView(
                          padding: EdgeInsets.all(8),
                          margin: 16,
                          radius: 12,
                          color: Color(0xffF9F9F9))
                      .onTap(() {
                    Alerts.yesOrNoDialog(context,
                        title: LocaleKeys.my_ads_keys_delete_ad.tr(),
                        content:
                            LocaleKeys.my_ads_keys_delete_ad_confirmation.tr(),
                        action1title: LocaleKeys.settings_cancel.tr(),
                        action2title: LocaleKeys.my_ads_keys_delete.tr(),
                        action2: () async {
                      final res = await locator<GeneralRepo>().deleteAll();
                      if (res == true) cubit.myAdscontroller.refresh();
                    }, action2Color: Colors.red);
                  }),
              ],
        */
            ),
            body: Column(
              children: [
                20.ph,
                TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  labelPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    color: context.primaryColor,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (s) {
                    //   cubit.tabindexUnit = s;
                    setState(() {});
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  controller: cubit.tabController,
                  unselectedLabelColor: context.primaryColor.withOpacity(.07),
                  splashFactory: NoSplash.splashFactory,
                  isScrollable: false,
                  tabs: [
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        // width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: cubit.tabController.index == 0
                                ? context.primaryColor
                                : context.primaryColor.withOpacity(.07),
                            borderRadius: BorderRadius.circular(33)),
                        child: CustomText(
                          LocaleKeys.navBar_my_ads.tr(),
                          fontSize: 14,
                          weight: FontWeight.w700,
                          align: TextAlign.center,
                          color: cubit.tabController.index == 0
                              ? Colors.white
                              : context.primaryColor,
                        ),
                      ),
                    ),
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        // width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: cubit.tabController.index == 1
                                ? context.primaryColor
                                : context.primaryColor.withOpacity(.07),
                            borderRadius: BorderRadius.circular(33)),

                        child: CustomText(
                          LocaleKeys.home_keys_my_orders.tr(),
                          fontSize: 14,
                          weight: FontWeight.w700,
                          align: TextAlign.center,
                          color: cubit.tabController.index == 1
                              ? Colors.white
                              : context.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                16.ph,
                Expanded(
                    child: TabBarView(
                  controller: cubit.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MyAdsTab(
                      controller: cubit.myAdscontroller,
                      initPagination: () {
                        cubit.addPageoffersLisnter("normal");
                      },
                      getAdDetails: (adId) async {
                        final res = await cubit.showAd(adId);
                        if (res != null)
                          Navigator.pushNamed(context, Routes.CreateGeneral,
                              arguments: res);
                      },
                    ),
                    MyAdsTab(
                      controller: cubit.myOrderscontroller,
                      initPagination: () {
                        cubit.addPageOrderLisnter("order");
                      },
                      getAdDetails: (adId) async {
                        final res = await cubit.showAd(adId);
                        if (res != null)
                          Navigator.pushNamed(context, Routes.CreateGeneral,
                              arguments: res);
                      },
                    ),
                  ],
                )),
                100.ph,
              ],
            ),
          );
        },
      ),
    );
  }
}
