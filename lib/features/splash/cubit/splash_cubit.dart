import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:device_uuid/device_uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Router/Router.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/firebase_message.dart';
import '../../../core/utils/utils.dart';
import '../domain/model/splash_model.dart';
import '../domain/repository/splash_repository.dart';
import 'splash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitial());
  static SplashCubit get(context) => BlocProvider.of(context);

  SplashRepository splashRepository = locator<SplashRepository>();

  // List<OnBoardingModel> onboarding = [];
  int sliderIndex = 0;
  late PageController controller;
  // cachImage(BuildContext context) {
  //   for (var model in Utils.onboarding) {
  //     precacheImage(NetworkImage(model.imageUrl ?? ""), context);
  //   }
  // }

  void updateSliderIndex(int index) {
    sliderIndex = index;
    emit(ChangeIntroState());
  }

  String? route;
  checkLogin() async {
    await Future.wait([
      FBMessging.initUniLinks(),
      Utils.dataManager.getUserData(),
    ]);
    Utils.uuid = await DeviceUuid().getUUID() ?? "ssssssss";
    log("uuid ${Utils.uuid}");
    log("Utils.token ${Utils.token}");

    // await Utils.deleteUserData();
    // await splashRepository.chechShowSubScribe();

    if (Utils.token.isNotEmpty) {
      final res = await getUserData();
      if (res == null) {
        await Utils.deleteUserData();
      }
      await Future.wait([
        dynamicLink(),
        if (res != true) getSplash(),
      ]);
      route = res == true
          ? Routes.LayoutScreen
          : Utils.onboarding.isEmpty
              ? Routes.LoginScreen
              : Routes.OnboardingScreen;
      // route = Routes.LayoutScreen;
      return /* Utils.fromNotification == true ? null : */ route;
    } else {
      await Future.wait([
        dynamicLink(),
        getSplash(),
      ]);
      route = /*  Utils.fromNotification == true ? null :  */
          Utils.onboarding.isEmpty
              ? Routes.LoginScreen
              : Routes.OnboardingScreen;
      return route;
    }
  }

  getUserData() async {
    final response = await splashRepository.getProfileRequest();
    if (response != null) {
      // final UserModel user = UserModel.fromJson(response)..token = Utils.token;
      await Utils.saveUserInHive(response);
      return true;
    }
    return null;
  }

  Future getSplash() async {
    final response = await splashRepository.getSplash();
    if (response != null) {
      Utils.onboarding = response.onboarding ?? [];
      emit(NewState());
      // log("message splash ${Utils.onboarding.first.toMap()}");
      // final UserModel user = UserModel.fromJson(response)..token = Utils.token;

      return true;
    }
    return null;
  }

  StreamSubscription<Uri>? streamALl;
  Future dynamicLink() async {
    final appLinks = AppLinks();

// Get the initial/first link.
// This is useful when app was terminated (i.e. not started)
// Do something (navigation, ...)

// Subscribe to further events when app is started.
// (Use stringLinkStream to get it as [String])
    // if (appLink != null) {
    streamALl = appLinks.uriLinkStream.listen((uri) {
      log(uri.path.toString(), name: "11111");
      String link = uri.path.toString();

      Utils.fromNotification = true;
      List<String> parts = link.split('/');

      // Get the last element of the split parts
      parts.removeLast();
      String id = parts.last;
      // log("event.queryParametersallUriLinkStream");
      log(uri.path.toString(), name: "path uriLinkStream");
      log(uri.fragment.toString(), name: "fragment uriLinkStream");
      log(id.toString(), name: "id uriLinkStream");

      (parts.contains("users") || parts.contains("shareLink"))
          ? Navigator.pushNamedAndRemoveUntil(
              Utils.navigatorKey().currentContext!,
              Routes.AdvistorScreen,
              arguments: id,
              (route) => false)
          : null;

      return;
    });
    // }
    // appLinks.allUriLinkStream.listen((uri) {
    //   log(uri.path.toString(), name: "222222");
    //   String link = uri.path.toString();
    //   if (link.contains("book")) {
    //     Utils.fromNotification = true;
    //     List<String> parts = link.split('/');

    //     // Get the last element of the split parts
    //     parts.removeLast();
    //     String id = parts.last;
    //     // log("event.queryParametersallUriLinkStream");
    //     log(uri.path.toString(), name: "path allUriLinkStream");
    //     log(uri.fragment.toString(), name: "fragment allUriLinkStream");
    //     log(id.toString(), name: "id allUriLinkStream");
    //     Navigator.pushNamedAndRemoveUntil(
    //         Utils.navigatorKey().currentContext!,
    //         Routes.NovelDetailsScreen,
    //         arguments: AutherDetailsArgs(
    //           id: id,
    //         ),
    //         (route) => false);
    //     this.id = id;
    //   }

    //   return;
    // });

// Maybe later. Get the latest link.
    // await appLinks.getLatestAppLink();
  }
}
