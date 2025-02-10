import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/core/utils/launcher.dart';
import 'package:pride/features/ad_details/domain/model/ad_details_model.dart';
import 'package:pride/shared/widgets/button_widget.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/login_dialog.dart';
import '../../cubit/ad_details_cubit.dart';
import '../../cubit/ad_details_states.dart';
import '../widgets/ad_features_section.dart';
import '../widgets/advistor_section.dart';
import '../widgets/category_features_section.dart';
import '../widgets/comment_section.dart';
import '../widgets/header_ad_details.dart';
import '../widgets/siminalar_ad_sections.dart';

class AdDetailsScreen extends StatefulWidget {
  const AdDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);
  final int id;
  @override
  State<AdDetailsScreen> createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  AdDetailsModel adDetailsModel = AdDetailsModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdDetailsCubit()..showAd(widget.id),
      child: BlocConsumer<AdDetailsCubit, AdDetailsStates>(
        listener: (context, state) {
          if (state is AdDetailsSuccess) {
            adDetailsModel = state.response;
          }
        },
        builder: (context, state) {
          final cubit = AdDetailsCubit.get(context);
          return Scaffold(
            body: LoadingAndError(
              isError: state is AdDetailsError,
              isLoading: state is AdDetailsLoading,
              function: () => cubit.showAd(widget.id),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  HeaderAdDetails(
                    innerBoxIsScrolled: innerBoxIsScrolled,
                    sliders: adDetailsModel.images ?? [],
                  )
                ],
                body: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                adDetailsModel.title ?? "",
                                color: context.secondaryColor,
                                weight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("time".svg()),
                                8.pw,
                                CustomText(
                                  (adDetailsModel.createdAt ?? "").formateDate,
                                  color: LightThemeColors.textHint,
                                  fontSize: 14,
                                  weight: FontWeight.w300,
                                ),
                              ],
                            ),
                          ],
                        ).paddingHorizontal(16),
                        8.ph,
                        Row(
                          children: [
                            CircleAvatar(
                                child: SvgPicture.asset("location".svg())),
                            8.pw,
                            CustomText(
                              LocaleKeys.home_keys_city.tr() + " :",
                              color: LightThemeColors.textHint,
                              fontSize: 14,
                              weight: FontWeight.w300,
                            ),
                            8.pw,
                            CustomText(
                              (adDetailsModel.address ?? ""),
                              color: context.secondaryColor,
                              weight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ],
                        ),
                        8.ph,
                        CustomText(
                          adDetailsModel.content ?? "",
                          color: LightThemeColors.textHint,
                          weight: FontWeight.w300,
                          fontSize: 16,
                          align: TextAlign.start,
                        ),
                        8.ph,
                        CategoryFeaturesSection(adDetailsModel: adDetailsModel),
                        20.ph,
                        adFeaturesSection(adDetailsModel: adDetailsModel),
                      ],
                    ).paddingHorizontal(16),
                    AdvisterSections(
                      adDetailsModel: adDetailsModel,
                      onSucess: () {
                        cubit.showAd(widget.id);
                      },
                    ),
                    20.ph,
                    CommentSections(adDetailsModel: adDetailsModel),
                    20.ph,
                    MapWidget(
                        latLng: LatLng(
                      double.parse(adDetailsModel.location?.lat ?? "20"),
                      double.parse(adDetailsModel.location?.lng ?? "20"),
                    )),
                    12.ph,
                    if (Utils.userModel.id != adDetailsModel.user?.id &&
                        Utils.userModel.token != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ButtonWidget(
                              radius: 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("message".svg()),
                                  8.pw,
                                  CustomText(
                                    LocaleKeys.my_ads_keys_message.tr(),
                                    color: Colors.white,
                                    weight: FontWeight.w700,
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Utils.token.isNotEmpty == true
                                    ? Navigator.pushNamed(
                                        context, Routes.ChatScreen, arguments: {
                                        "roomId": adDetailsModel.room_id
                                                ?.toString() ??
                                            "",
                                        "adId": adDetailsModel.id?.toString(),
                                        "userId":
                                            adDetailsModel.user?.id?.toString(),
                                      })
                                    : Alerts.bottomSheet(
                                        Utils.navigatorKey().currentContext!,
                                        child: const LoginDialog(),
                                        backgroundColor: Colors.white);

                                // if (adDetailsModel.has_chat == true) {
                                //   Navigator.pushNamed(
                                //       context, Routes.ChatScreen,
                                //       arguments:
                                //           adDetailsModel.room_id?.toString() ??
                                //               "");
                                // } else {
                                //   Alerts.yesOrNoDialog(context,
                                //       title: LocaleKeys.chat_cost.tr(),
                                //       action2Color: context.primaryColor,
                                //       content:
                                //           LocaleKeys.pay_consultation_cost.tr(),
                                //       action1title: LocaleKeys.no.tr(),
                                //       action2title: LocaleKeys.pay.tr(),
                                //       action2: () async {
                                //     final res = await cubit.startChat(
                                //         adDetailsModel.user?.id?.toString() ??
                                //             "");
                                //     if (res != null) {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (ctx) => WebViewPayment(
                                //                     url: res,
                                //                     onPaymentSuccess: () async {
                                //                       final roomId = await locator<
                                //                               GeneralRepo>()
                                //                           .getRoomId(
                                //                               brokerId:
                                //                                   adDetailsModel
                                //                                           .user
                                //                                           ?.id
                                //                                           ?.toString() ??
                                //                                       "");
                                //                       if (roomId != null) {
                                //                         Navigator.pop(context);
                                //                         adDetailsModel.room_id =
                                //                             roomId;
                                //                         adDetailsModel
                                //                             .has_chat = true;
                                //                         Navigator.pushNamed(
                                //                             context,
                                //                             Routes.ChatScreen,
                                //                             arguments: roomId);
                                //                       }
                                //                     },
                                //                   )));
                                //     }
                                //   });
                                // }
                              },
                              buttonColor: Color(0xff27AD38),
                            )),
                            if (adDetailsModel.show_phone == true) ...[
                              16.pw,
                              Expanded(
                                child: ButtonWidget(
                                  radius: 15,
                                  title: LocaleKeys.my_ads_keys_call.tr(),
                                  onTap: () {
                                    Utils.token.isNotEmpty == true
                                        ? LauncherHelper.call(
                                            adDetailsModel.user?.phone ?? "")
                                        : Alerts.bottomSheet(
                                            Utils.navigatorKey()
                                                .currentContext!,
                                            child: const LoginDialog(),
                                            backgroundColor: Colors.white);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("call".svg()),
                                      8.pw,
                                      CustomText(
                                        LocaleKeys.my_ads_keys_call.tr(),
                                        color: Colors.white,
                                        weight: FontWeight.w700,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    20.ph,
                    SimilarAdSections(adDetailsModel: adDetailsModel)
                        .paddingHorizontal(16),
                    20.ph,
                    if (Utils.userModel.id == adDetailsModel.user?.id &&
                        Utils.token.isNotEmpty)
                      ButtonWidget(
                        radius: 15,
                        title: LocaleKeys.settings_edit.tr(),
                        onTap: () {
                          Navigator.pushNamed(context, Routes.CreateGeneral,
                              arguments: adDetailsModel);
                        },
                        buttonColor: context.primaryColor,
                      ).paddingHorizontal(16),
                    20.ph,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  const MapWidget({
    super.key,
    required this.latLng,
  });

  final LatLng? latLng;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(45.521563, -120.677433);

  // LatLng? _lastMapPosition;
  Marker marker = Marker(
    markerId: MarkerId('selectedLocation'),
    position: LatLng(45.521563, -122.677433),
  );

  void _onMapCreated(GoogleMapController controller) {
    if (widget.latLng != null) {
      controller.animateCamera(CameraUpdate.newLatLng(widget.latLng!));
      marker = Marker(
        markerId: MarkerId('selectedLocation'),
        position: widget.latLng!,
      );
    }
    mapController = controller;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: GoogleMap(
          mapToolbarEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: _onMapCreated,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          compassEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 8.0,
          ),
          markers: {marker}),
    );
  }
}
