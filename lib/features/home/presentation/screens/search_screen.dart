import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/services/alerts.dart';
import 'package:pride/core/theme/light_theme.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/cubit/home_states.dart';
import 'package:pride/features/home/domain/request/home_request.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/customtext.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/general/general_repo.dart';
import '../../../../core/general/models/area_model.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/paged_autocomplete.dart';
import '../../cubit/home_cubit.dart';
import '../../domain/model/ads_model.dart';
import '../widgets/ad_Widget.dart';
import '../widgets/search_price.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.filterSearch});
  final FilterSearch filterSearch;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<GeneralModel> type = [
    GeneralModel(name: LocaleKeys.my_ads_keys_rent, id: 'rent'),
    GeneralModel(name: LocaleKeys.my_ads_keys_sell, id: 'sell'),
  ];
  int? roomNum;
  final city = TextEditingController();
  @override
  void dispose() {
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleAppBar: LocaleKeys.home_keys_search.tr(),
      ),
      body: BlocProvider(
        create: (context) => HomeCubit()
          ..filterSearch = widget.filterSearch
          ..addPageoffersLisnter(),
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            final cubit = HomeCubit.get(context);
            return RefreshIndicator(
              onRefresh: () async {
                cubit.myAdscontroller.refresh();
              },
              child: Column(
                children: [
                  12.ph,
                  TextFormFieldWidget(
                    type: TextInputType.name,
                    controller: TextEditingController()
                      ..text = cubit.filterSearch.keyword ?? "",
                    hintText: LocaleKeys.home_keys_required_field.tr(),
                    prefixIcon: "search".svg(),
                    borderRadius: 15,
                    suffixIcon: "filter".svg().toSvg(),
                    password: false,
                    onFieldSubmitted: (value) {
                      cubit.filterSearch.keyword = value;
                      cubit.myAdscontroller.refresh();
                    },
                  ).paddingHorizontal(16),
                  12.ph,
                  SizedBox(
                    height: 75,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: CustomAutoCompleteTextField<GeneralModel>(
                              borderColor: LightThemeColors.textHint,
                              hint: LocaleKeys.my_ads_keys_type.tr(),
                              itemAsString: (p0) => p0.name?.tr() ?? '',
                              showSufix: true,
                              localData: true,
                              function: (search) => type,
                              borderRadius: 10,
                              onChanged: (value) {
                                cubit.filterSearch.type = value.id;
                                cubit.myAdscontroller.refresh();
                              },
                            ),
                          ),
                          8.pw,
                          SizedBox(
                            width: 150,
                            child: PagedCustomAutoCompleteTextField<AreaModel>(
                              hint: LocaleKeys.my_ads_keys_select_Area.tr(),
                              itemAsString: (p0) => p0.name ?? '',
                              borderRaduis: 10,
                              borderColor: LightThemeColors.textHint,
                              showSufix: true,
                              onPage: (page, search) async =>
                                  (await locator<GeneralRepo>().getArea(
                                    page: page,
                                  ))
                                      ?.areas ??
                                  [],
                              onChanged: (value) {
                                cubit.filterSearch.area_id = value.id;
                                city.clear();
                                cubit.myAdscontroller.refresh();
                              },
                            ),
                          ),
                          8.pw,
                          SizedBox(
                            width: 150,
                            child: CustomAutoCompleteTextField<AreaModel>(
                              borderRadius: 10,
                              controller: city,
                              enabled: cubit.filterSearch.area_id != null,
                              borderColor: LightThemeColors.textHint,
                              hint: LocaleKeys.my_ads_keys_select_city.tr(),
                              itemAsString: (p0) => p0.name ?? '',
                              showSufix: true,
                              function: (search) async =>
                                  (await locator<GeneralRepo>().getCities(
                                    id: cubit.filterSearch.area_id?.toString(),
                                  ))
                                      ?.areas ??
                                  [],
                              onChanged: (value) {
                                cubit.filterSearch.city_id = value.id;
                                cubit.myAdscontroller.refresh();
                              },
                            ),
                          ),
                          8.pw,
                          GestureDetector(
                            onTap: () => Alerts.dialog(context,
                                child: SearchPrice(
                                  min: (cubit.filterSearch.min_price != null)
                                      ? cubit.filterSearch.min_price?.toDouble()
                                      : null,
                                  max: (cubit.filterSearch.max_price != null)
                                      ? cubit.filterSearch.max_price?.toDouble()
                                      : null,
                                  result: (min, max) {
                                    if (min != null && min != "")
                                      cubit.filterSearch.min_price =
                                          min.toInt();
                                    if (max != null && max != "")
                                      cubit.filterSearch.max_price =
                                          max.toInt();
                                    cubit.myAdscontroller.refresh();
                                  },
                                )),
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(bottom: 30),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: LightThemeColors.textHint,
                                ),
                              ),
                              child: CustomText(
                                LocaleKeys.my_ads_keys_set_price.tr(),
                                color: LightThemeColors.textHint,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          8.pw,
                          GestureDetector(
                            onTap: () {
                              Alerts.dialog(context, child:
                                  StatefulBuilder(builder: (context, set) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            LocaleKeys.home_keys_the_rooms.tr(),
                                            fontSize: 20,
                                          ),
                                        ],
                                      ),
                                      12.ph,
                                      Wrap(
                                        children: [
                                          for (int i = 1; i < 10; i++)
                                            GestureDetector(
                                              onTap: () {
                                                roomNum = i;
                                                set(() {});
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(8),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: i == roomNum
                                                      ? context.primaryColor
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xffC7C7C7),
                                                      width: .5),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: CustomText(
                                                  i.toString(),
                                                  color: i == roomNum
                                                      ? Colors.white
                                                      : context.primaryColor,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      12.ph,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButtonWidget(
                                            fontweight: FontWeight.w400,
                                            size: 14,
                                            function: () {
                                              cubit.filterSearch.room_no = null;
                                              roomNum = null;
                                              cubit.myAdscontroller.refresh();
                                              Navigator.pop(context);
                                            },
                                            text: "delete".tr(),
                                            color: Colors.red,
                                          ),
                                          ButtonWidget(
                                            width: 80,
                                            height: 30,
                                            radius: 10,
                                            fontSize: 16,

                                            onTap: () {
                                              cubit.filterSearch.room_no =
                                                  roomNum;
                                              cubit.myAdscontroller.refresh();
                                              Navigator.pop(context);
                                            },
                                            title: "verify".tr(),
                                            // color: Colors.green,
                                          ),
                                          // ElevatedButton(
                                          //   onPressed: () {
                                          //     Navigator.pop(context);
                                          //   },
                                          //   child: CustomText(
                                          //     "LocaleKeys.home_keys_cancel"
                                          //         .tr(),
                                          //     color: Colors.white,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }));
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.only(bottom: 30),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: LightThemeColors.textHint,
                                ),
                              ),
                              child: CustomText(
                                LocaleKeys.home_keys_the_rooms.tr(),
                                color: LightThemeColors.textHint,
                                fontSize: 15,
                              ),
                            ), /*  SizedBox(
                              width: 150,
                              child: CustomAutoCompleteTextField<int>(
                                borderRadius: 10,
                                borderColor: LightThemeColors.textHint,
                                hint: LocaleKeys.home_keys_the_rooms.tr(),
                                itemAsString: (p0) => p0.toString(),
                                showSufix: true,
                                function: (search) =>
                                    List.generate(10, (s) => s + 1),
                                onChanged: (value) {
                                  cubit.filterSearch.room_no = value;
                                  cubit.myAdscontroller.refresh();
                                },
                              ),
                            ), */
                          ),
                        ],
                      ),
                    ),
                  ).paddingHorizontal(16),
                  // 12.ph,
                  Expanded(
                    child: PagedListView.separated(
                      separatorBuilder: (context, index) => 8.ph,
                      pagingController: cubit.myAdscontroller,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      builderDelegate: PagedChildBuilderDelegate<AdsModel>(
                        noItemsFoundIndicatorBuilder: (context) => Center(
                          child: Text('no_items'.tr()),
                        ),
                        itemBuilder: (context, item, index) {
                          return AdWidget(
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
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
