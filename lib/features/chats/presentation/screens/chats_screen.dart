import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pride/core/Router/Router.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/services/alerts.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/core/utils/utils.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/button_widget.dart';
import 'package:pride/shared/widgets/customtext.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/media/alert_of_media.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loadinganderror.dart';
import '../../../../shared/widgets/location_picker_screen.dart';
import '../../../home/domain/model/ads_model.dart';
import '../../cubit/chats_cubit.dart';
import '../../cubit/chats_states.dart';
import '../widgets/widgets.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleAppBar: LocaleKeys.chat.tr(),
      ),
      bottomNavigationBar: const SizedBox(
        height: 95,
      ),
      body: Column(
        children: [
          20.ph,
          TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            labelPadding: EdgeInsets.zero,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(33),
              color: context.primaryColor,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (s) {
              //   cubit.tabindexUnit = s;
              setState(() {});
            },
            physics: const NeverScrollableScrollPhysics(),
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            controller: tabController,
            unselectedLabelColor: context.primaryColor.withOpacity(.07),
            splashFactory: NoSplash.splashFactory,
            isScrollable: false,
            tabs: [
              Tab(
                iconMargin: EdgeInsets.zero,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  // width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: tabController.index == 0
                          ? context.primaryColor
                          : context.primaryColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(33)),
                  child: CustomText(
                    LocaleKeys.ads.tr(),
                    fontSize: 14,
                    weight: FontWeight.w700,
                    align: TextAlign.center,
                    color: tabController.index == 0
                        ? Colors.white
                        : context.primaryColor,
                  ),
                ),
              ),
              Tab(
                iconMargin: EdgeInsets.zero,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  // width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: tabController.index == 1
                          ? context.primaryColor
                          : context.primaryColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(33)),

                  child: CustomText(
                    LocaleKeys.real_estate_agents.tr(),
                    fontSize: 14,
                    weight: FontWeight.w700,
                    align: TextAlign.center,
                    color: tabController.index == 1
                        ? Colors.white
                        : context.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          16.ph,
          Expanded(
              child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ChatsTab(isMulti: true),
              ChatsTab(isMulti: false),
            ],
          )),
        ],
      ),
    );
  }
}

class ChatsTab extends StatefulWidget {
  const ChatsTab({
    super.key,
    required this.isMulti,
  });

  final bool isMulti;

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit()
        ..getChats(
          multiple: widget.isMulti,
        ),
      child: BlocConsumer<ChatsCubit, ChatsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = ChatsCubit.get(context);
          return LoadingAndError(
            isError: state is ChatsError,
            isLoading: state is ChatsLoading,
            function: () {
              cubit.getChats(
                multiple: widget.isMulti,
              );
            },
            child: RefreshIndicator(
              onRefresh: () => cubit.getChats(
                multiple: widget.isMulti,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: cubit.chats.isEmpty
                        ? EmptyWidget(
                            image: "sms",
                            color: Color(0xffBEBEBE),
                            title: LocaleKeys.no_msg,
                            subtitle: LocaleKeys.no_msg_you,
                          )
                        : ListView.separated(
                            itemCount: cubit.chats.length,
                            padding: const EdgeInsets.all(16),
                            itemBuilder: (context, index) {
                              return ChatWidget(
                                chatModel: cubit.chats[index],
                                key: ObjectKey(cubit.chats[index]),
                                isMulti: widget.isMulti,
                              );
                            },
                            separatorBuilder: (_, i) => 18.ph,
                          ),
                  ),
                  if (Utils.userModel.type != 'broker')
                    ButtonWidget(
                      title: LocaleKeys.upgrade_membership.tr(),
                      onTap: () {
                        Alerts.yesOrNoDialog(context,
                            title: LocaleKeys
                                .upgrade_membership_as_real_estate_broker
                                .tr(),
                            content: LocaleKeys
                                .please_attach_license_for_verification
                                .tr(),
                            action2title: LocaleKeys.attach.tr(),
                            action1title: LocaleKeys.settings_cancel.tr(),
                            child: UpgradeMemberShipDialog(
                              cubit: cubit,
                            ),
                            action2Color: context.primaryColor,
                            action2: () async {
                          if (cubit.image == null || cubit.image?.path == '') {
                            Alerts.snack(
                                text: LocaleKeys
                                    .please_attach_license_for_verification
                                    .tr(),
                                state: SnackState.failed);
                            return;
                          } else if (cubit.locationModel.lat == null ||
                              cubit.locationModel.lng == null) {
                            Alerts.snack(
                                text: LocaleKeys
                                    .please_attach_location_for_verification
                                    .tr(),
                                state: SnackState.failed);
                            return;
                          }
                          final res = await cubit.upgradeMemperShip();
                          if (res == true) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.splashScreen, (route) => false);
                            // Navigator.pop(context);
                          }
                        }, action1: () {
                          cubit.image = null;
                          cubit.adLocationController.clear();
                          cubit.locationModel = LocationModel();
                          setState(() {});
                          Navigator.pop(context);
                        });
                      },
                    ).paddingAll(16),
                  12.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}

class UpgradeMemberShipDialog extends StatefulWidget {
  const UpgradeMemberShipDialog({
    super.key,
    // required this.locationModel,
    // required this.adLocationController,
    required this.cubit,
  });
  // LocationModel locationModel;
  // TextEditingController adLocationController;
  final ChatsCubit? cubit;
  @override
  State<UpgradeMemberShipDialog> createState() =>
      _UpgradeMemberShipDialogState();
}

class _UpgradeMemberShipDialogState extends State<UpgradeMemberShipDialog> {
  late ChatsCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // cubit = ChatsCubit.get(context);
    cubit = widget.cubit!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormFieldWidget(
          type: TextInputType.number,
          hintText: "broker_loc".tr(),
          onTap: () async {
            final List? res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LocationPickerScreen(),
              ),
            );
            if (res != null) {
              final Placemark placemark = res[1].first;
              cubit.locationModel = LocationModel(
                lat: res[0].latitude.toString(),
                lng: res[0].longitude.toString(),
                address: "${placemark.country ?? ''} ${placemark.street ?? ''}",
              );

              cubit.adLocationController.text =
                  cubit.locationModel.address ?? '';
            }
          },
          password: false,
          validator: (v) => Utils.valid.defaultValidation(v),
          controller: cubit.adLocationController,
          suffixIcon: CircleAvatar(
            backgroundColor: context.primaryColor.withOpacity(.18),
            child: SvgPicture.asset(
              "location".svg(),
            ),
          ).paddingAll(8),
        ),
        12.ph,
        TextFormFieldWidget(
          readOnly: true,
          onTap: () {
            Alerts.bottomSheet(
              context,
              child: AlertOfMedia(
                cameraTap: (image) {
                  cubit.image = image;
                  setState(() {});
                },
                galleryTap: (image) {
                  cubit.image = image;
                  print(cubit.image);
                  setState(() {});
                },
              ),
            );
          },
          hintText: LocaleKeys.attach_license.tr(),
          password: false,
        ),
        if (cubit.image != null && cubit.image!.path != '')
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                cubit.image ?? File(''),
                width: 250,
                fit: BoxFit.fill,
                height: 100,
              ).paddingAll(16)),
      ],
    );
  }
}
