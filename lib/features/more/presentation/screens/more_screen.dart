import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/app_strings/locale_keys.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/core/utils/utils.dart';
import 'package:pride/features/more/domain/repository/repository.dart';
import 'package:pride/shared/widgets/loadinganderror.dart';
import '../../../../core/Router/Router.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../core/utils/launcher.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/myLoading.dart';
import '../../cubit/more_cubit.dart';
import '../../cubit/more_states.dart';
import '../widgets/appbar_more.dart';
import '../widgets/btns.dart';
import '../widgets/lang.dart';
import '../widgets/widgets.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late Future<dynamic> data;
  @override
  void initState() {
    data = locator<MoreRepository>().contact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit()
        ..getUserData()
        ..pages(),
      child: BlocConsumer<MoreCubit, MoreStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = MoreCubit.get(context);
          return Scaffold(
            appBar:
                (Utils.token.isNotEmpty == true) ? AppbarMore() : AppbarMore(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TitleProfile(
                      title: LocaleKeys.settings_settings, icon: "setting"),
                  if ((Utils.token.isNotEmpty == true))
                    ProfileItem(
                      title: LocaleKeys.change_password,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.ChangePassScreen,
                            arguments: (o, n, rn) async {
                          final res = await cubit.changePass(o, n, rn);
                          if (res == true) {
                            Navigator.pop(context);
                          }
                        });
                      },
                    ),
                  if ((Utils.token.isNotEmpty == true))
                    ProfileItem(
                      title: LocaleKeys.favorites,
                      onTap: () {
                        Navigator.pushNamed(context, Routes.FavouriteScreen);
                      },
                    ),

                  ProfileItem(
                    title: 'language',
                    onTap: () {
                      Alerts.bottomSheet(context,
                          child: const LangSheet(),
                          backgroundColor: context.background);
                    },
                  ),

                  // ProfileItem(
                  //   title: LocaleKeys.settings_commission_account,
                  //   onTap: () {
                  //     Navigator.pushNamed(context, Routes.aboutUS,
                  //         arguments: AboutUsArgs(
                  //             title: LocaleKeys.settings_commission_account,
                  //             type: "commetions"));
                  //   },
                  // ),
                  // ProfileItem(
                  //   title: LocaleKeys.settings_real_estate_broker_membership,
                  //   onTap: () {
                  //     Navigator.pushNamed(context, Routes.aboutUS,
                  //         arguments: AboutUsArgs(
                  //             title: LocaleKeys
                  //                 .settings_real_estate_broker_membership,
                  //             type: "borker_membership"));
                  //   },
                  // ),
                  // ProfileItem(
                  //   title: LocaleKeys.settings_real_estate_company_membership,
                  //   onTap: () {
                  //     Navigator.pushNamed(context, Routes.aboutUS,
                  //         arguments: AboutUsArgs(
                  //             title: LocaleKeys
                  //                 .settings_real_estate_company_membership,
                  //             type: "membership"));
                  //   },
                  // ),
                  TitleProfile(title: LocaleKeys.settings_help, icon: "info"),
                  ProfileItem(
                    title: LocaleKeys.settings_contact_us,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.ContactUs);
                    },
                  ),
                  ProfileItem(
                    title: LocaleKeys.settings_complain,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.complainScreen);
                    },
                  ),
                  // ProfileItem(
                  //   title: LocaleKeys.settings_app_policy,
                  //   onTap: () {
                  //     Navigator.pushNamed(context, Routes.aboutUS,
                  //         arguments: AboutUsArgs(
                  //             title: LocaleKeys.settings_app_policy,
                  //             type: "policy"));
                  //   },
                  // ),
                  ...List.generate(
                    cubit.pagesModel.data?.length ?? 0,
                    (index) => ProfileItem(
                      title: cubit.pagesModel.data?[index].title ?? "",
                      onTap: () {
                        Navigator.pushNamed(context, Routes.aboutUS,
                            arguments: AboutUsArgs(
                                title:
                                    cubit.pagesModel.data?[index].title ?? "",
                                type: cubit.pagesModel.data?[index].id
                                        ?.toString() ??
                                    ""));
                      },
                    ),
                  ),
                  // ProfileItem(
                  //   title: LocaleKeys.settings_app_usage_agreement,
                  //   onTap: () {
                  //     Navigator.pushNamed(context, Routes.aboutUS,
                  //         arguments: AboutUsArgs(
                  //             title: LocaleKeys.settings_app_usage_agreement,
                  //             type: "use_agreement"));
                  //   },
                  // ),
                  if (Utils.token.isNotEmpty == true) DeleteAccBtn(),
                  if (Utils.token.isNotEmpty == true) LogoutBtn(),
                  if (Utils.token.isEmpty == true)
                    ProfileItem(
                      title: LocaleKeys.auth_login.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.LoginScreen);
                      },
                    ),
                  28.ph,
                  // if (false)
                  FutureBuilder(
                      future: data,
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Center(
                                child: MyLoading.loadingWidget(),
                              )
                            : LoadingAndError(
                                isError:
                                    snapshot.hasError && snapshot.data == null,
                                isLoading: snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.connectionState ==
                                        ConnectionState.active,
                                child: Column(
                                  children: [
                                    Image.asset("logo".png('icons'),
                                        height: 200),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomText(
                                      LocaleKeys.settings_contact_social.tr(),
                                      weight: FontWeight.w800,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        if (snapshot.data["linkedin"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["linkedin"]),
                                            child: Image.asset(
                                              "linked".png("icons"),
                                            ),
                                          ),
                                        if (snapshot.data["facebook"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["facebook"]),
                                            child: Image.asset(
                                              "face".png("icons"),
                                            ),
                                          ),
                                        if (snapshot.data["tiktok"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["tiktok"]),
                                            child: Image.asset(
                                              "tik".png("icons"),
                                            ),
                                          ),
                                        if (snapshot.data["instagram"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["instagram"]),
                                            child: Image.asset(
                                              "insta".png("icons"),
                                            ),
                                          ),
                                        if (snapshot.data["snapshat"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["snapshat"]),
                                            child: Image.asset(
                                              "snap".png("icons"),
                                            ),
                                          ),

                                        /*  if (snapshot.data["twitter"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["twitter"]),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.primaryColor
                                                      .withOpacity(.1)),
                                              child: SvgPicture.asset(
                                                "twitter".svg(),
                                                color: context.primaryColor,
                                              ),
                                            ),
                                          ),
                                        if (snapshot.data["snapchat"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["snapchat"]),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.primaryColor
                                                      .withOpacity(.1)),
                                              child: SvgPicture.asset(
                                                "snap".svg(),
                                                color: context.primaryColor,
                                              ),
                                            ),
                                          ),
                                        if (snapshot.data["facebook"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["facebook"]),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.primaryColor
                                                      .withOpacity(.1)),
                                              child: SvgPicture.asset(
                                                "face_s".svg(),
                                                color: context.primaryColor,
                                              ),
                                            ),
                                          ),
                                        if (snapshot.data["whatsapp"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper
                                                    .openWhatsApp(snapshot
                                                        .data["whatsapp"]),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.primaryColor
                                                      .withOpacity(.1)),
                                              child: SvgPicture.asset(
                                                "whats_s".svg(),
                                                color: context.primaryColor,
                                              ),
                                            ),
                                          ),
                                        if (snapshot.data["instagram"] != null)
                                          GestureDetector(
                                            onTap: () async =>
                                                await LauncherHelper.openUrl(
                                                    snapshot.data["instagram"]),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: context.primaryColor
                                                      .withOpacity(.1)),
                                              child: SvgPicture.asset(
                                                "instagram".svg(),
                                                color: context.primaryColor,
                                              ),
                                            ),
                                          ),
                                      */
                                      ],
                                    ),
                                  ],
                                ),
                              );
                      }),
                  88.ph,
                ],
              ).paddingAll(16),
            ),
          );
        },
      ),
    );
  }
}
