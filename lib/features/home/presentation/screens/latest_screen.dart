import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/general/general_repo.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../home/domain/model/ads_model.dart';
import '../../../home/presentation/widgets/ad_Widget.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_states.dart';
import '../../domain/request/home_request.dart';

class LatestScreen extends StatefulWidget {
  const LatestScreen({Key? key, required this.keySearch, required this.title})
      : super(key: key);
  final String? title;
  final String? keySearch;

  @override
  State<LatestScreen> createState() => _LatestScreenState();
}

class _LatestScreenState extends State<LatestScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<AdsModel> response = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..filterSearch = FilterSearch(
          main_type: widget.keySearch,
        )
        ..addPageoffersLisnter(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: DefaultAppBar(
              titleAppBar: widget.title ?? '',
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                cubit.myAdscontroller.refresh();
              },
              child: PagedListView.separated(
                separatorBuilder: (context, index) => 8.ph,
                pagingController: cubit.myAdscontroller,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          );
        },
      ),
    );
  }
}
