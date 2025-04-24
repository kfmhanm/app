import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/services/alerts.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/domain/model/home_model.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/customtext.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/login_dialog.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';
import '../../domain/request/home_request.dart';
import '../widgets/ad_list.dart';
import '../widgets/dialog_search.dart';
import '../widgets/filter_secction.dart';
import '../widgets/home_slider.dart';
import '../widgets/tab_bar_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  HomeModel? homemodel;
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getHome(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is HomeSuccess) {
            homemodel = state.response;
            Utils.max_price = homemodel?.max_price ?? "10000";
          }
        },
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: DefaultAppBar(
              titleAppBar: LocaleKeys.home.tr(),
              actions: [
                SvgPicture.asset("circle_notification".svg())
                    .paddingDirectionalOnly(end: 16.0)
                    .onTap(() {
                  Utils.token.isNotEmpty == true
                      ? Navigator.pushNamed(context, Routes.NotificationsScreen)
                      : Alerts.dialog(Utils.navigatorKey().currentContext!,
                          child: const LoginDialog(),
                          backgroundColor: Colors.white);
                }),
              ],
              leading: SvgPicture.asset("map".svg()).onTap(() {
                Utils.token.isNotEmpty == true
                    ? Navigator.pushNamed(context, Routes.MapsScreen)
                    : Alerts.dialog(Utils.navigatorKey().currentContext!,
                        child: const LoginDialog(),
                        backgroundColor: Colors.white);
              }),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                _current = 0;
                cubit.filterSearch = FilterSearch();
                cubit.getHome();
              },
              child: LoadingAndError(
                isError: state is HomeError,
                isLoading: state is HomeLoading,
                function: () {
                  cubit.filterSearch = FilterSearch();
                  cubit.getHome();
                },
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      12.ph.SliverBox,
                      TextFormFieldWidget(
                        type: TextInputType.name,
                        hintText: LocaleKeys.home_keys_required_field.tr(),
                        prefixIcon: "search".svg(),
                        borderRadius: 15,
                        suffixIcon: InkWell(
                            onTap: () {
                              Alerts.dialog(
                                context,
                                child: DialogSearch(result: (filter) {
                                  cubit.filterSearch =
                                      cubit.filterSearch.copyWith(
                                    area_id: filter.area_id,
                                    city_id: filter.city_id,
                                    type: filter.type,
                                  );
                                  print(cubit.filterSearch.toMap());
                                  Navigator.pushNamed(
                                      context, Routes.SearchScreen,
                                      arguments: cubit.filterSearch);
                                }).setContainerToView(
                                    padding: EdgeInsets.all(16),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                              );
                            },
                            child: "filter".svg().toSvg()),
                        password: false,
                        controller: _searchController,
                        onFieldSubmitted: (value) {
                          cubit.filterSearch.keyword = value;
                          Navigator.pushNamed(context, Routes.SearchScreen,
                              arguments: cubit.filterSearch);
                        },
                      ).paddingHorizontal(16).SliverBox,
                      12.ph.SliverBox,
                      HomeSlider(
                        sliders: homemodel?.sliders,
                      ).SliverBox,
                      12.ph.SliverBox,
                      // if (Utils.userModel.type == "broker")
                      TabTypeHome(
                        onTap: (index) {
                          _current = index;
                          setState(() {});
                        },
                      ).SliverBox,
                      FilterSecction(
                        categories: homemodel?.categories,
                        onFilter: (s) {
                          cubit.filterSearch.keyword = _searchController.text;
                          cubit.getHome(false);
                          // Navigator.pushNamed(context, Routes.SearchScreen,
                          //     arguments: cubit.filterSearch);
                        },
                        onRestore: (s) {
                          _searchController.clear();
                          cubit.filterSearch = FilterSearch();
                          Navigator.pushNamed(context, Routes.SearchScreen,
                              arguments: cubit.filterSearch);
                        },
                      ).SliverPadding,
                      // if (_current == 0 && homemodel?.ads?.isEmpty == true)
                      //   Center(
                      //     child: CustomText(
                      //       "no_ads".tr(),
                      //       color: context.secondaryColor,
                      //     ),
                      //   ).SliverPadding,
                      // if (_current == 1 && homemodel?.order?.isEmpty == true)
                      //   Center(
                      //     child: CustomText(
                      //       "no_orders".tr(),
                      //       color: context.secondaryColor,
                      //     ),
                      //   ).SliverPadding,
                      SliverListAd(
                        adLists: _current == 0
                            ? homemodel?.ads ?? []
                            : homemodel?.order ?? [],

                        // adLists: homemodel?.ads ?? [],
                      ),
                      12.ph.SliverBox,
                      if (_current == 0 &&
                          homemodel?.latestAds?.isNotEmpty == true) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              LocaleKeys.home_keys_latest_ads.tr(),
                              weight: FontWeight.w700,
                              color: context.secondaryColor,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.LatestScreen, arguments: {
                                  "title": LocaleKeys.home_keys_latest_ads.tr(),
                                  "keySearch": "normal"
                                });
                              },
                              icon: CustomText(
                                LocaleKeys.home_keys_view_more.tr(),
                                color: LightThemeColors.textHint,
                              ),
                            ),
                          ],
                        ).SliverPadding
                      ],
                      if (_current == 1 &&
                          homemodel?.latest_order?.isNotEmpty == true) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              "latest_orders".tr(),
                              weight: FontWeight.w700,
                              color: context.secondaryColor,
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.LatestScreen, arguments: {
                                  "title": "latest_orders".tr(),
                                  "keySearch": "order"
                                });
                              },
                              icon: CustomText(
                                LocaleKeys.home_keys_view_more.tr(),
                                color: LightThemeColors.textHint,
                              ),
                            ),
                          ],
                        ).SliverPadding
                      ],
                      12.ph.SliverBox,
                      SliverListAd(
                        adLists: _current == 0
                            ? homemodel?.latestAds ?? []
                            : homemodel?.latest_order ?? [],
                      ),
                      12.ph.SliverBox,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
