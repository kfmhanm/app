import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/general/general_repo.dart';
import 'package:pride/core/utils/Locator.dart';
import 'package:pride/features/home/domain/model/ads_model.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../home/presentation/widgets/ad_Widget.dart';
import '../../../home/presentation/widgets/widgets.dart';
import '../../cubit/ad_details_cubit.dart';
import '../../cubit/ad_details_states.dart';

class SimilarAds extends StatefulWidget {
  const SimilarAds({super.key, required this.adId});
  final int adId;
  @override
  State<SimilarAds> createState() => _SimilarAdsState();
}

class _SimilarAdsState extends State<SimilarAds> {
  List<AdsModel> ads = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleAppBar: LocaleKeys.my_ads_keys_similar_ads.tr(),
      ),
      body: BlocProvider(
        create: (context) => AdDetailsCubit()..getSimilarAd(widget.adId),
        child: BlocConsumer<AdDetailsCubit, AdDetailsStates>(
          listener: (context, state) {
            if (state is SimilarAdSuccess) {
              ads = state.response;
            }
          },
          builder: (context, state) {
            final cubit = AdDetailsCubit.get(context);
            return LoadingAndError(
              isError: state is SimilarAdError,
              isLoading: state is SimilarAdLoading,
              function: () => cubit.getSimilarAd(widget.adId),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: ads.length,
                itemBuilder: (context, index) {
                  return AdWidget(
                    adsModel: ads[index],
                    favTap: () async {
                      ads[index].isFavorite = !(ads[index].isFavorite ?? false);
                      setState(() {});
                      final res = await locator<GeneralRepo>()
                          .toggleFavorite(ads[index].id);
                      if (res != true) {
                        ads[index].isFavorite =
                            !(ads[index].isFavorite ?? false);
                        setState(() {});
                      }
                    },
                  ).paddingVertical(4);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
