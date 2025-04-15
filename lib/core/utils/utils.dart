import 'dart:developer';

import 'package:device_uuid/device_uuid.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pride/core/Router/Router.dart';
import 'package:pride/core/utils/firebase_message.dart';
import 'package:pride/core/utils/launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:math' hide log;
import '../../features/splash/domain/model/splash_model.dart';
import '../../shared/widgets/login_dialog.dart';
import '../app_strings/locale_keys.dart';
import '../data_source/hive_helper.dart';
import '../general/general_repo.dart';
import '../general/models/user_model.dart';
import '../services/alerts.dart';
import '../services/media/my_media.dart';
import 'Locator.dart';
import 'validations.dart';

class Utils {
  static String?
      nafathtoken; //that come from notification if it was in background
static bool ios=false;
  static String token = '';
  static String lang = '';
  static String max_price = '0';
  static String FCMToken = '';
  static String userType = "";
  static String room_id = "";
  static List<OnBoardingModel> onboarding = [];
  static bool fromNotification = false;
  static String uuid = "";
  static UserModel userModel = UserModel();
  static GlobalKey<NavigatorState> navigatorKey() =>
      locator<GlobalKey<NavigatorState>>();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static MyMedia get myMedia => locator<MyMedia>();

  static Validation get valid => locator<Validation>();
  static DataManager get dataManager => locator<DataManager>();
  static isLogged(fun) async {
    // log("isLogged------${Utils.token.isNotEmpty == true}");
    Utils.token.isNotEmpty == true
        ? () {
            log("isLogged");

            fun.call();
          }
        : Alerts.bottomSheet(Utils.navigatorKey().currentContext!,
            child: const LoginDialog(), backgroundColor: Colors.white);
  }

  static saveUserInHive(
    Map<String, dynamic> response,
  ) async {
    userModel = UserModel.fromJson(response);
    token = userModel.token ?? '';
    await Utils.dataManager.saveUser({
      'access_token': token,
    });
  }

  static logout() async {
    Utils.uuid = await DeviceUuid().getUUID() ?? "ssssssss";
    final res = await locator<GeneralRepo>().logout();
    if (res == true) {
      await Utils.deleteUserData();

      // await Future.wait(
      //     [FBMessging.deleteToken(), dataManager.deleteUserData()]);
      // await FBMessging.deleteToken();
      // await FBMessging.unSubscripeclient();
      navigatorKey()
          .currentState!
          .pushNamedAndRemoveUntil(Routes.LoginScreen, (route) => false);
    }
  }

  static rate({
    required BuildContext context,
    required int userId,
    int? adId,
    Function? onSucess,
  }) async {
    double rating = 3;
    Alerts.yesOrNoDialog(
      context,
      title: LocaleKeys.my_ads_keys_advertiser_rating.tr(),
      content: LocaleKeys.my_ads_keys_rate_advertiser.tr(),
      action1title: LocaleKeys.settings_cancel.tr(),
      action2title: LocaleKeys.my_ads_keys_rating.tr(),
      action2: () async {
        await locator<GeneralRepo>()
            .rateAdvistor(rate: rating, advistorId: userId, adId: adId);
        if (onSucess != null) onSucess.call();
        Navigator.pop(context);
      },
      action2Color: Color(0xffFFBD3C),
      child: RatingBar.builder(
        itemBuilder: (context, index) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        textDirection: TextDirection.ltr,
        initialRating: rating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemSize: 20,
        tapOnlyMode: true,
        itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
        onRatingUpdate: (rate) {
          rating = rate;
        },
        ignoreGestures: false,
      ),
    );
  }

  static deleteUserData() async {
    userModel = UserModel();
    token = '';
    FCMToken = "";
    await Future.wait([
      FBMessging.deleteToken(),
      dataManager.deleteUserData(),
      FBMessging.unSubscripeclient()
    ]);
    nafathtoken == null;
  }

  static void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  static void fixRtlLastChar(TextEditingController? controller) {
    if (controller != null) {
      if (controller.selection ==
          TextSelection.fromPosition(
              TextPosition(offset: (controller.text.length) - 1))) {
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      }
    }
  }

  static genrateBarcode() {
    return (Random().nextInt(99999999) + 10000000).toString();
  }

  static double getSizeOfFile(File file) {
    final size = file.readAsBytesSync().lengthInBytes;
    final kb = size / 1024;
    final mb = kb / 1024;
    print(mb);
    return mb;
  }

static Future<bool> requestNotificationPermission({BuildContext? mycontext}) async {
var context=mycontext??navigatorKey().currentContext!;
  NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    return true;
  }

  // Request permission
  settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    return true;
  } else {
    // If denied, show a popup
    _showSettingsDialog(context);
    return false;
  }
}
  static void redirectToNafath() async {
    final String url = Platform.isIOS ? 'nafath://home' : 'nic://nafath';
    final String otherlink = Platform.isIOS ? 'https://apps.apple.com/us/app/%D9%86%D9%81%D8%A7%D8%B0-nafath/id1598909871' : 'https://play.google.com/store/apps/details?id=sa.gov.nic.myid';
      await LauncherHelper.openApp(url,otherlink);
    
  }
}

extension Login on dynamic {
  // SliverToBoxAdapter get SliverBox => SliverToBoxAdapter(
  //   child: this,
  // );
  isLogged() async {
    // log("isLogged------${Utils.token.isNotEmpty == true}");
    Utils.token.isNotEmpty == true
        ? () {
            log("isLogged");

            this.call();
          }
        : Alerts.bottomSheet(Utils.navigatorKey().currentContext!,
            child: const LoginDialog(), backgroundColor: Colors.white);
  }
}
void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("إذن الإشعارات"),
      content: const Text(
          "الإشعارات معطلة. يرجى تمكينها من الإعدادات لتلقي التحديثات."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // إغلاق النافذة المنبثقة
          child: const Text("إلغاء"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await openAppSettings(); // فتح إعدادات الجهاز
          },
          child: const Text("الانتقال إلى الإعدادات"),
        ),
      ],
    ),
  );

}