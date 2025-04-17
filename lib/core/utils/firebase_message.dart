import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:pride/core/Router/Router.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/general/nafath/nafath_cubit.dart';

import 'package:pride/core/utils/utils.dart';

import '../../features/splash/domain/repository/splash_repository.dart';
import '../../firebase_options.dart';
import 'Locator.dart';

class FBMessging {
  static AndroidNotificationChannel androidChannel() {
    return const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
  }

  static Future<void> enableIosNotify() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    //  handleNafathLogin(message);
    print(
      message.data.toString(),
    );
    log(message.data.toString(), name: "omar");
    log(message.toString(), name: "omar22");
    print(message.notification.toString());
    print(
      message.notification?.title?.toString() ?? 'no notificationtitke',
    );
    print(message.notification?.body?.toString() ?? 'no notificationtitke');
    //print(message.notification?..toString()??'no notificationtitke');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // handleNafathLogin(message);
    // if (message.notification?.title == "Nafath token") {}
    // if (message.data["type"] == "nafath") {
    //   //  final appDocumentDir = await getApplicationDocumentsDirectory();
    //   //Hive.init(appDocumentDir.path);
    //   // final authBox = await Hive.openBox('data');

    //   //  String token = message.data['message'];

    //   //   await authBox.put('nafathtoken', token);
    // }
  }

  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  @pragma('vm:entry-point')
  static Future<void> initUniLinks() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      badge: true,
      provisional: false,
    );
    AndroidNotificationChannel channel = androidChannel();
    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    AndroidInitializationSettings androidsettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosSetting =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentSound: true,
    );
    InitializationSettings settings = InitializationSettings(
      iOS: iosSetting,
      android: androidsettings,
    );

    plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        print(response.payload);

        FCMNotification notification =
            FCMNotification.fromJson(response.payload ?? "");
        print(notification.toMap());

        handleNotification(
          notification,
          appIsopened: true,
        );
      },
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      log(value?.toMap().toString() ?? "noooooo", name: "getInitialMessage");
      print(
        value?.toMap().toString() ?? "noooooo",
      );
      if (value != null) {
        // handleNafathLogin(value);

        FCMNotification notification = FCMNotification.fromMap(value.data);
        handleNotification(
          notification,
          appIsopened: false,
        );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (RouteGenerator.currentRoute == Routes.LoginScreen) {
        handleNafathLogin(message);
      }
      log(message.data.toString(), name: "onMessage Nocheck");
      print(message.data.toString() + "onMessage Nocheck");
      print(Utils.room_id.toString() + "Utils.room_id");
      FCMNotification notificationModel = FCMNotification.fromMap(message.data);
      if (message.notification != null) {
        log(message.data.toString(), name: "onMessageData");
        log(message.toMap().toString(), name: "onMessage");
        log(message.toMap().toString(), name: "onMessage");
        print(message.data.toString() + "onMessageData");
        print(message.toMap().toString() + "onMessage");
        print(message.toMap().toString() + "onMessage");
        if (notificationModel.type == "reject_broker") {
          locator<SplashRepository>().getProfileRequest(true);
          return;
        }
        if (notificationModel.type == "account_deactivated") {
          Utils.deleteUserData();
          Navigator.of(Utils.navigatorKey().currentContext!)
              .pushNamedAndRemoveUntil(
            Routes.LoginScreen,
            (route) => false,
          );
          return;
        }
        if ((notificationModel.model_id == Utils.room_id &&
            notificationModel.type == 'chat')) return;

        plugin.show(
          payload: notificationModel.toJson(),
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      log(message.data.toString(), name: "onMessageOpenedApp");
      handleNafathLogin(message);

      FCMNotification notification = FCMNotification.fromMap(message.data);
      handleNotification(
        notification,
        appIsopened: false,
      );
    });

    NotificationSettings requestSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // await FirebaseMessaging.instance.subscribeToTopic('topic');
    await getToken();
    // print('subscribe to topic');
  }

  static getToken() async {
    await messaging.getToken().then((tokenFcm) {
      print(tokenFcm);
      Utils.FCMToken = tokenFcm ?? '';
      // print(Utils.FCMToken);
    });
  }

  static Future<void> deleteToken() async {
    await messaging.deleteToken();
  }

  // // subscripe to topic all users
  static Future subscripeclient() async {
    await messaging.subscribeToTopic("topic");
  }

  static Future unSubscripeclient() async {
    await messaging.unsubscribeFromTopic("topic");
  }

  // // subscripe to topic all users
  // static Future subscripeAllconsultant() async {
  //   await messaging.subscribeToTopic("consultant");
  // }

  // static Future unSubscripeAllconsultant() async {
  //   await messaging.unsubscribeFromTopic("consultant");
  // }
  static handleNafathLogin(
    RemoteMessage notification,
  ) async {
    if (notification.data["type"] == "nafath") {
      log(notification.data.toString(), name: "nafathnotification");
      log(Utils.nafathtoken.toString(), name: "nafathnotification2");

      /*  await Utils
          .saveData('nafathtoken', notification.data["message"])
          .then((e) async {

   //     log(await Utils.dataManager.getData('nafathtoken').toString(),
    //        name: "nafathnotification3");
      });*/

      Utils.navigatorKey()
          .currentContext!
          .read<NafathCubit>()
          .loginRequestFromNotification(notification.data["message"]);
    }
  }

  static handleNotification(FCMNotification notification,
      {bool appIsopened = false}) {
    print("sssss");
    log(notification.toMap().toString(), name: "omar");

    if (notification.type == "reject_broker") {
      locator<SplashRepository>().getProfileRequest(true);
      return;
    }
    if (notification.type == "chat") {
      if (appIsopened) {
        if (RouteGenerator.currentRoute == Routes.ChatScreen) {
          Utils.room_id = "";
          Navigator.pop(Utils.navigatorKey().currentState!.context);
          Future.delayed(
            const Duration(
              milliseconds: 500,
            ),
            () => Navigator.pushNamed(
              Utils.navigatorKey().currentContext!,
              Routes.ChatScreen,
              arguments: {
                "roomId": notification.model_id,
                "adId": notification.ad_id
              }..removeWhere((key, value) => value == null),
            ),
          );
        } else {
          Navigator.pushNamed(
            Utils.navigatorKey().currentContext!,
            Routes.ChatScreen,
            arguments: {
              "roomId": notification.model_id,
              "adId": notification.ad_id
            }..removeWhere((key, value) => value == null),
          );
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
          Utils.navigatorKey().currentContext!,
          Routes.LayoutScreen,
          (route) => false,
        );
        Navigator.pushNamed(
          Utils.navigatorKey().currentContext!,
          Routes.ChatScreen,
          arguments: {
            "roomId": notification.model_id,
            "adId": notification.ad_id
          }..removeWhere((key, value) => value == null),
        );
      }
    } else if (notification.type == "ad") {
      if (appIsopened) {
        if (RouteGenerator.currentRoute == Routes.AdDetailsScreen) {
          Navigator.pop(Utils.navigatorKey().currentContext!);
          Navigator.pushNamed(
            Utils.navigatorKey().currentContext!,
            Routes.AdDetailsScreen,
            arguments: notification.ad_id.toInt(),
          );
        } else {
          Navigator.pushNamed(
            Utils.navigatorKey().currentContext!,
            Routes.AdDetailsScreen,
            arguments: notification.ad_id.toInt(),
          );
        }
      } else {
        Navigator.pushNamed(
          Utils.navigatorKey().currentContext!,
          Routes.AdDetailsScreen,
          arguments: notification.ad_id.toInt(),
        );
      }
    }
  }
}

class FCMNotification {
  String? type;
  String? ad_id;
  String? model_id;
  FCMNotification({
    this.type,
    this.ad_id,
    this.model_id,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (type != null) {
      result.addAll({'type': type});
    }
    if (ad_id != null) {
      result.addAll({'ad_id': ad_id});
    }
    if (model_id != null) {
      result.addAll({'room_id': model_id});
    }

    return result;
  }

  factory FCMNotification.fromMap(Map<String, dynamic> map) {
    return FCMNotification(
      type: map['type'],
      ad_id: map['ad_id']?.toString(),
      model_id: map['room_id']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory FCMNotification.fromJson(String source) =>
      FCMNotification.fromMap(json.decode(source));
}
