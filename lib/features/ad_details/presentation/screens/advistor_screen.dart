import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/general/models/user_model.dart';
import 'package:pride/core/theme/light_theme.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/core/utils/utils.dart';
import 'package:pride/features/ad_details/cubit/ad_details_states.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/profile_image.dart';
import '../../../home/presentation/widgets/ad_list.dart';
import '../../cubit/ad_details_cubit.dart';

class AdvistorScreen extends StatefulWidget {
  const AdvistorScreen({super.key, required this.profileId});
  final int profileId;
  @override
  State<AdvistorScreen> createState() => _AdvistorScreenState();
}

class _AdvistorScreenState extends State<AdvistorScreen> {
  UserModel user = UserModel();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // canPop: true,
      onWillPop: () async {
        if (Navigator.canPop(context)) {
          Navigator.pop(
            context,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.LayoutScreen, (route) => false);
        }

        return false;
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          titleAppBar: LocaleKeys.my_ads_keys_ad_owner.tr(),
        ),
        body: BlocProvider(
          create: (context) =>
              AdDetailsCubit()..getAdvistorProfile(widget.profileId),
          child: BlocConsumer<AdDetailsCubit, AdDetailsStates>(
            listener: (context, state) {
              if (state is AdvistorProfileSuccess) user = state.response;
            },
            builder: (context, state) {
              final cubit = AdDetailsCubit.get(context);
              return LoadingAndError(
                isError: state is AdvistorProfileError,
                isLoading: state is AdvistorProfileLoading,
                function: cubit.getAdvistorProfile,
                child: CustomScrollView(
                  slivers: [
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 8),
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    ProfileImage(
                                      height: 25,
                                      image: user.image,
                                      color: context.primaryColor,
                                    ),
                                    16.pw,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          overflow: TextOverflow.ellipsis,
                                          user.name ?? '',
                                          fontSize: 12,
                                          weight: FontWeight.w700,
                                          color: context.primaryColor,
                                        ),
                                        Row(children: [
                                          RatingBar.builder(
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            textDirection: TextDirection.ltr,
                                            initialRating:
                                                (user.avgRate?.toString() ??
                                                        "0")
                                                    .toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            // itemCount: 2,
                                            itemSize: 20,
                                            tapOnlyMode: true,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0.0),

                                            onRatingUpdate: (rating) {},
                                            ignoreGestures: true,
                                          ),
                                          8.pw,
                                          Row(
                                            children: [
                                              CustomText(
                                                "( ${(user.avgRate?.toString() ?? "0").toDouble().roundTo2numberString} )",
                                                color: Color(0xff818181),
                                              ),
                                              4.pw,
                                              CustomText(
                                                LocaleKeys.my_ads_keys_rating
                                                    .tr(),
                                                color: Color(0xff818181),
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ],
                                          ).onTap(() {
                                            if (Utils.userModel.id != user.id &&
                                                Utils.userModel.token != null)
                                              Utils.rate(
                                                context: context,
                                                userId: user.id ?? 0,
                                                onSucess: () {
                                                  cubit.getAdvistorProfile(
                                                      widget.profileId);
                                                },
                                              );
                                          }),
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).SliverBox,
                    20.ph.SliverBox,
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 16),
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    user.isVerified == true
                                        ? Row(
                                            children: [
                                              SvgPicture.asset(
                                                  "verified".svg()),
                                              4.pw,
                                              CustomText(
                                                LocaleKeys
                                                    .my_ads_keys_trusted_account
                                                    .tr(),
                                                color: context.secondaryColor,
                                                weight: FontWeight.w700,
                                              ),
                                            ],
                                          )
                                        : CustomText(
                                            LocaleKeys
                                                .my_ads_keys_untrusted_account
                                                .tr(),
                                            color: context.secondaryColor,
                                            weight: FontWeight.w700,
                                          ),
                                    CustomText(
                                      LocaleKeys.my_ads_keys_member_since.tr() +
                                          " ${(user.date_broker ?? "").formateDate}",
                                      color: LightThemeColors.textHint,
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset("verified".svg()),
                                        4.pw,
                                        CustomText(
                                          " ${user.ads?.length.toString() ?? "0"} ${LocaleKeys.my_ads_keys_ad.tr()}",
                                          // user.ads?.length.toString() ??
                                          // "0" +
                                          //     " " +
                                          //     LocaleKeys.my_ads_keys_ad
                                          //         .tr(),
                                          color: context.secondaryColor,
                                          weight: FontWeight.w700,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).SliverBox,
                    20.ph.SliverBox,
                    SliverListAd(
                      adLists: user.ads ?? [],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
