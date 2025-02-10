import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/domain/request/home_request.dart';
import 'package:pride/shared/widgets/button_widget.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/general/general_repo.dart';
import '../../../../core/general/models/area_model.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/paged_autocomplete.dart';

class DialogSearch extends StatefulWidget {
  const DialogSearch({
    super.key,
    required this.result,
  });

  final void Function(FilterSearch) result;

  @override
  State<DialogSearch> createState() => _DialogSearchState();
}

class _DialogSearchState extends State<DialogSearch> {
  FilterSearch filterSearch = FilterSearch();
  List<GeneralModel> type = [
    GeneralModel(name: LocaleKeys.my_ads_keys_rent, id: 'rent'),
    GeneralModel(name: LocaleKeys.my_ads_keys_sell, id: 'sell'),
  ];
  final city = TextEditingController();
  @override
  void dispose() {
    city.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 5,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        ),
        28.ph,
        CustomText(
          LocaleKeys.home_keys_filter_by.tr(),
          weight: FontWeight.w700,
          fontSize: 16,
        ),
        28.ph,
        Row(
          children: [
            Expanded(
              child: PagedCustomAutoCompleteTextField<AreaModel>(
                hint: LocaleKeys.my_ads_keys_select_Area.tr(),
                itemAsString: (p0) => p0.name ?? '',
                showSufix: true,
                onPage: (page, search) async =>
                    (await locator<GeneralRepo>().getArea(
                      page: page,
                    ))
                        ?.areas ??
                    [],
                onChanged: (value) {
                  filterSearch.area_id = value.id;
                  city.clear();
                  setState(() {});
                },
              ),
            ),
            12.pw,
            Expanded(
              child: CustomAutoCompleteTextField<AreaModel>(
                hint: LocaleKeys.my_ads_keys_select_city.tr(),
                enabled: filterSearch.area_id != null,
                controller: city,
                itemAsString: (p0) => p0.name ?? '',
                showSufix: true,
                function: (search) async =>
                    (await locator<GeneralRepo>().getCities(
                      id: filterSearch.area_id?.toString(),
                    ))
                        ?.areas ??
                    [],
                onChanged: (value) {
                  filterSearch.city_id = value.id;
                },
              ),
            )
          ],
        ),
        12.ph,
        CustomAutoCompleteTextField<GeneralModel>(
          hint: LocaleKeys.my_ads_keys_type.tr(),
          itemAsString: (p0) => p0.name?.tr() ?? '',
          showSufix: true,
          localData: true,
          function: (search) => type,
          onChanged: (value) {
            filterSearch.type = value.id;
          },
        ),
        12.ph,
        ButtonWidget(
          title: LocaleKeys.home_keys_filter.tr(),
          onTap: () {
            Navigator.pop(context);
            widget.result.call(filterSearch);
          },
        ),
        12.ph,
      ],
    );
  }
}
