import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/core/utils/utils.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/button_widget.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';
import '../../domain/model/home_model.dart';
import '../../domain/request/home_request.dart';

class FilterSecction extends StatefulWidget {
  const FilterSecction(
      {super.key,
      required this.categories,
      required this.onRestore,
      required this.onFilter});
  final List<CategoriesModel>? categories;
  final void Function(FilterSearch filterSearch)? onRestore;
  final void Function(FilterSearch filterSearch)? onFilter;
  @override
  State<FilterSecction> createState() => _FilterSecctionState();
}

class _FilterSecctionState extends State<FilterSecction> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.categories?.isNotEmpty == true) ...[
              20.ph,
              CustomText(
                LocaleKeys.home_keys_main_and_sub_categories_of_real_estate
                    .tr(),
                color: context.secondaryColor,
                fontSize: 16,
                weight: FontWeight.w700,
              ),
              ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        final item = widget.categories?[i];
                        final isSelect =
                            cubit.filterSearch.category_id == item?.id;

                        return CustomText(
                          widget.categories?[i].title ?? "",
                          color: isSelect
                              ? Colors.white
                              : LightThemeColors.textHint,
                        )
                            .setContainerToView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                margin: 8,
                                color: isSelect
                                    ? context.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                borderColor: isSelect
                                    ? context.primaryColor
                                    : LightThemeColors.textHint)
                            .onTap(() {
                          cubit.filterSearch.category_id = item?.id;
                          cubit.filterSearch.sub_category_id = null;
                          setState(() {});
                          cubit.getSubCategories();
                          widget.onFilter?.call(cubit.filterSearch);
                        });
                      },
                      itemCount: widget.categories?.length)
                  .setContainerToView(
                height: 60,
              )
            ],
            if (cubit.subCategories?.isNotEmpty == true) ...[
              12.ph,
              ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        final item = cubit.subCategories?[i];
                        final isSelect =
                            cubit.filterSearch.sub_category_id == item?.id;

                        return CustomText(
                          item?.title ?? "",
                          color: isSelect
                              ? Colors.white
                              : LightThemeColors.textHint,
                        )
                            .setContainerToView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                margin: 8,
                                color: isSelect
                                    ? context.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                borderColor: isSelect
                                    ? context.primaryColor
                                    : LightThemeColors.textHint)
                            .onTap(() {
                          cubit.filterSearch.sub_category_id = item?.id;
                          widget.onFilter?.call(cubit.filterSearch);
                          setState(() {});
                        });
                      },
                      itemCount: cubit.subCategories?.length)
                  .setContainerToView(
                height: 60,
              )
            ],
            12.ph,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ButtonWidget(
            //       title: LocaleKeys.search.tr(),
            //       withBorder: true,
            //       buttonColor: Colors.white,
            //       textColor: context.primaryColor,
            //       width: 100,
            //       height: 50,
            //       onTap: () {
            //         widget.onFilter?.call(cubit.filterSearch);
            //       },
            //     ),
            //     22.pw,
            //     ButtonWidget(
            //       title: LocaleKeys.restore.tr(),
            //       withBorder: true,
            //       buttonColor: Colors.white,
            //       textColor: context.primaryColor,
            //       width: 100,
            //       height: 50,
            //       onTap: () {
            //         widget.onRestore?.call(FilterSearch());
            //         setState(() {});
            //       },
            //     ),
            //   ],
            // ),
            // 12.ph,
          ],
        );
      },
    );
  }
}
