import 'package:flutter/material.dart';
import 'package:pride/features/home/domain/model/ads_model.dart';

import '../../../../core/general/general_repo.dart';
import '../../../../core/utils/Locator.dart';
import 'ad_Widget.dart';

class SliverListAd extends StatefulWidget {
  const SliverListAd({super.key, required this.adLists});
  final List<AdsModel> adLists;
  @override
  State<SliverListAd> createState() => _SliverListAdState();
}

class _SliverListAdState extends State<SliverListAd> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemCount: widget.adLists.length,
        itemBuilder: (context, index) {
          return AdWidget(
            adsModel: widget.adLists[index],
            favTap: () async {
              widget.adLists[index].isFavorite =
                  !(widget.adLists[index].isFavorite ?? false);
              setState(() {});
              final res = await locator<GeneralRepo>()
                  .toggleFavorite(widget.adLists[index].id);
              if (res != true) {
                widget.adLists[index].isFavorite =
                    !(widget.adLists[index].isFavorite ?? false);
                setState(() {});
              }
            },
          );
        },
      ),
    );
  }
}
