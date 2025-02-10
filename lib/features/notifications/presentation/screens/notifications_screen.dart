import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../cubit/notifications_cubit.dart';
import '../../cubit/notifications_states.dart';
import '../../domain/model/notifications_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..addPageoffersLisnter(),
      child: BlocConsumer<NotificationsCubit, NotificationsStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = NotificationsCubit.get(context);
          return Scaffold(
            appBar: DefaultAppBar(
              titleAppBar: LocaleKeys.notifications_keys_notifications.tr(),
              actions: [
                if (cubit.notificationscontroller.itemList?.isNotEmpty ?? false)
                  SvgPicture.asset("delete".svg())
                      .setContainerToView(
                          padding: EdgeInsets.all(8),
                          margin: 16,
                          radius: 12,
                          color: Color(0xffF9F9F9))
                      .onTap(() {
                    Alerts.yesOrNoDialog(context,
                        title: LocaleKeys
                            .notifications_keys_delete_all_notifications
                            .tr(),
                        content: LocaleKeys
                            .notifications_keys_delete_all_notifications_confirmation
                            .tr(),
                        action1title: LocaleKeys.settings_cancel.tr(),
                        action2title: LocaleKeys.my_ads_keys_delete.tr(),
                        action2: () async {
                      await cubit.deleteAllNotification();
                    }, action2Color: Colors.red);
                  }),
              ],
            ),
            body: SafeArea(
              child: PagedListView<int, NotificationModel>(
                pagingController: cubit.notificationscontroller,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("no_notification".svg()),
                        12.ph,
                        CustomText(
                          LocaleKeys.notifications_keys_no_notifications_yet
                              .tr(),
                          color: context.secondaryColor,
                          weight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        8.ph,
                        CustomText(
                          LocaleKeys.notifications_keys_no_notifications.tr(),
                          color: LightThemeColors.textHint,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context, item, index) {
                    return Slidable(
                        key: ValueKey(item.id),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            CustomSlidableAction(
                              onPressed: (ctx) async {
                                Alerts.yesOrNoDialog(context,
                                    title: LocaleKeys
                                        .notifications_keys_delete_notification
                                        .tr(),
                                    content: LocaleKeys
                                        .notifications_keys_delete_notification_confirmation
                                        .tr(),
                                    action1title:
                                        LocaleKeys.settings_cancel.tr(),
                                    action2title: LocaleKeys.my_ads_keys_delete
                                        .tr(), action2: () async {
                                  await cubit
                                      .deleteNotification(item.id.toString());
                                  Navigator.pop(context);
                                }, action2Color: Colors.red);
                              },
                              backgroundColor: Color(0xFFFFBEBE),
                              foregroundColor: Colors.white,
                              child: SizedBox(
                                width: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "delet".svg(),
                                      color: Colors.red,
                                    ),
                                    8.ph,
                                    CustomText(
                                      'Delete'.tr(),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ],
                        ),
                        child: NotificationWidget(notificationModel: item));
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

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.notificationModel,
  });

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    final cubit = NotificationsCubit.get(context);
    return GestureDetector(
      onTap: () async {
        switch (notificationModel.data?.type) {
          case "ad":
            // if (notificationModel.modelId != null)
            //   Navigator.pushNamed(context, Routes.AdDetailsScreen,
            //       arguments: notificationModel.modelId?.toString());
            break;
          // case "user":
          //   if (notificationModel.modelId != null)
          //     Navigator.pushNamed(context, Routes.FollowersDetailsScreen,
          //         arguments: FollowerArgs(
          //           id: (notificationModel.modelId?.toString()) ?? "",
          //         ));

          //   break;
          // case "chat":
          //   if (notificationModel.modelId != null)
          //     Navigator.pushNamed(context, Routes.ChatScreen,
          //         arguments: notificationModel.modelId?.toString());

          //   break;

          default:
        }
      },
      child: Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: ListTile(
                title: CustomText(
                  notificationModel.data?.title ?? "",
                  color: context.secondaryColor,
                ),
                subtitle: CustomText(
                  notificationModel.data?.message ?? "",
                  color: LightThemeColors.textHint,
                ),
                leading: SvgPicture.asset("notifi_item".svg()),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    notificationModel.createdAt ?? "",
                    color: LightThemeColors.textHint,
                    weight: FontWeight.w300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
