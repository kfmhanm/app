import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/general/general_repo.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../home/domain/model/ads_model.dart';
import '../../../home/presentation/widgets/ad_Widget.dart';
import '../../cubit/more_cubit.dart';
import '../../cubit/more_states.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<AdsModel> response = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit()..getFavourite(),
      child: BlocConsumer<MoreCubit, MoreStates>(
        listener: (context, state) {
          if (state is MoreFavSuccess) {
            response = state.response;
          }
        },
        builder: (context, state) {
          final cubit = MoreCubit.get(context);
          return Scaffold(
              appBar: DefaultAppBar(
                titleAppBar: LocaleKeys.favorites.tr(),
              ),
              body: LoadingAndError(
                isError: state is MoreFavError,
                isLoading: state is MoreFavLoading,
                function: () {
                  cubit.getFavourite();
                },
                child: response.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: response.length,
                        itemBuilder: (context, index) {
                          return AdWidget(
                            adsModel: response[index],
                            favTap: () async {
                              // response[index].isFavorite =
                              //     !(response[index].isFavorite ?? false);
                              // setState(() {});
                              final res = await locator<GeneralRepo>()
                                  .toggleFavorite(response[index].id);
                              if (res == true) {
                                response.removeAt(index);
                                // response[index];
                                setState(() {});
                              }
                            },
                          ).paddingVertical(4);
                        },
                      )
                    : Center(
                        child: CustomText(
                          "no_fav".tr(),
                        ),
                      ),
              ));
        },
      ),
    );
  }
}
