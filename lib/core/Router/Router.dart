import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/features/ad_details/domain/model/ad_details_model.dart';
import 'package:pride/features/static_page/presentation/complain.dart';
import '../../features/ad_details/presentation/screens/ad_comments_screen.dart';
import '../../features/ad_details/presentation/screens/ad_details_screen.dart';
import '../../features/ad_details/presentation/screens/advistor_screen.dart';
import '../../features/ad_details/presentation/screens/similar_ads.dart';
import '../../features/auth/presentation/screens/forget_password/forget_password_screen.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/otp/otp_screen.dart';
import '../../features/auth/presentation/screens/reset_password/reset_password_screen.dart';
import '../../features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import '../../features/chats/presentation/screens/chat_screen.dart';
import '../../features/chats/presentation/screens/photo_screen.dart';
import '../../features/create_ad/presentation/screens/create_ad_screen.dart';
import '../../features/create_ad/presentation/screens/create_general.dart';
import '../../features/create_ad/presentation/screens/features_screen.dart';
import '../../features/home/domain/request/home_request.dart';
import '../../features/home/presentation/screens/latest_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';
import '../../features/layout/presentation/screens/layout_screen.dart';
import '../../features/maps/presentation/screens/maps_screen.dart';
import '../../features/more/presentation/screens/favourite_screen.dart';
import '../../features/more/presentation/screens/more_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/change_pass.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/cubit/splash_cubit.dart';
import '../../features/splash/presentation/screens/on_boarding/on_boarding_screen.dart';
import '../../features/splash/presentation/screens/splash/splash.dart';
import '../../features/static_page/presentation/about_us.dart';
import '../../features/static_page/presentation/contact_us.dart';

class Routes {
  static const String splashScreen = "/splashScreen";
  static const String imageFullScreen = "/imageFullScreen";
  static const String OnboardingScreen = "/OnboardingScreen";
  static const String ChatScreen = "/ChatScreen";

  static const String LoginScreen = "LoginScreen";
  static const String RegisterScreen = "RegisterScreen";
  static const String forget_passScreen = "/forgetPassScreen";
  static const String OtpScreen = "/OtpScreen";
  static const String LayoutScreen = "/LayoutScreen";
  static const String ResetPasswordScreen = "/ResetPasswordScreen";
  static const String AdDetailsScreen = "AdDetailsScreen";
  static const String AdvistorScreen = "AdvistorScreen";
  static const String NotificationsScreen = "NotificationsScreen";
  static const String AdCommentsScreen = "AdCommentsScreen";
  static const String SimilarAds = "SimilarAds";
  static const String CreateAdScreen = "CreateAdScreen";
  static const String FeaturesScreen = "FeaturesScreen";
  static const String CreateGeneral = "CreateGeneral";
  static const String MoreScreen = "MoreScreen";
  static const String ContactUs = "ContactUs";
  static const String ChangePassScreen = "ChangePassScreen";
  static const String ProfileScreen = "ProfileScreen";
  static const String aboutUS = "aboutUS";
  static const String complainScreen = "ComplainScreen";
  static const String FavouriteScreen = "FavouriteScreen";
  static const String SearchScreen = "SearchScreen";
  static const String MapsScreen = "MapsScreen";
  static const String LatestScreen = "LatestScreen";
}

class RouteGenerator {
  static String currentRoute = "";

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      case Routes.splashScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const SplashScreen();
            });
      case Routes.aboutUS:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return AboutUS(
                title: (routeSettings.arguments as AboutUsArgs).title,
                type: (routeSettings.arguments as AboutUsArgs).type,
              );
            });
      case Routes.complainScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const ComplainScreen();
            });
      case Routes.OnboardingScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return BlocProvider(
                create: (context) => SplashCubit()
                  // ..cachImage(context)
                  ..controller = PageController(initialPage: 0),
                child: const OnboardingScreen(),
              );
            });
      case Routes.ProfileScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const ProfileScreen();
            });
      case Routes.FavouriteScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const FavouriteScreen();
            });
      // case Routes.CreateAdScreen:
      //   return CupertinoPageRoute(
      //       settings: routeSettings,
      //       builder: (_) {
      //         return const CreateAdScreen();
      //       });
      case Routes.ChangePassScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return ChangePassScreen(
                changePass:
                    routeSettings.arguments as Function(String, String, String),
              );
            });
      case Routes.imageFullScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return FullImageScreen(
                  sendFunction:
                      (routeSettings.arguments as ImageArgs).sendFunction,
                  photo: (routeSettings.arguments as ImageArgs).image,
                  url: (routeSettings.arguments as ImageArgs).url);
            });
      case Routes.CreateGeneral:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return CreateGeneral(
                adDetailsModel: routeSettings.arguments as AdDetailsModel?,
              );
            });
      case Routes.SearchScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return SearchScreen(
                filterSearch: routeSettings.arguments as FilterSearch,
              );
            });
      case Routes.LoginScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const LoginScreen();
            });
      case Routes.ContactUs:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const ContactUs();
            });
      case Routes.AdCommentsScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return AdCommentsScreen(
                adId: routeSettings.arguments as int,
              );
            });
      case Routes.SimilarAds:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return SimilarAds(
                adId: routeSettings.arguments as int,
              );
            });
      // case Routes.FeaturesScreen:
      //   return CupertinoPageRoute(
      //       settings: routeSettings,
      //       builder: (_) {
      //         return FeaturesScreen(
      //             // adId: routeSettings.arguments as int,
      //             );
      //       });
      case Routes.NotificationsScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const NotificationsScreen();
            });
      case Routes.ResetPasswordScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return ResetPasswordScreen(
                code: (routeSettings.arguments as NewPasswordArgs).code,
                mobile: (routeSettings.arguments as NewPasswordArgs).mobile,
              );
            });
      case Routes.OtpScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return OtpScreen(
                onReSend: (routeSettings.arguments as OtpArguments).onReSend,
                onSubmit: (routeSettings.arguments as OtpArguments).onSubmit,
                sendTo: (routeSettings.arguments as OtpArguments).sendTo,
                init: (routeSettings.arguments as OtpArguments).init,
              );
            });
      case Routes.ChatScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return ChatScreen(
                roomId: (routeSettings.arguments as Map)["roomId"],
                adId: (routeSettings.arguments as Map)["adId"],
                userId: (routeSettings.arguments as Map)["userId"],
                username: (routeSettings.arguments as Map)["username"],
              );
            });

      case Routes.LatestScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return LatestScreen(
                keySearch: (routeSettings.arguments as Map)["keySearch"],
                title: (routeSettings.arguments as Map)["title"],
              );
            });
      case Routes.MapsScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return MapsScreen();
            });
      case Routes.forget_passScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const ForgetPasswordScreen();
            });
      case Routes.RegisterScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const SignUpScreen();
            });
      case Routes.LayoutScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const LayoutScreen();
            });
      case Routes.AdDetailsScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return AdDetailsScreen(
                id: routeSettings.arguments as int,
              );
            });
      case Routes.MoreScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return const MoreScreen();
            });
      case Routes.AdvistorScreen:
        return CupertinoPageRoute(
            settings: routeSettings,
            builder: (_) {
              return AdvistorScreen(
                profileId: routeSettings.arguments as int,
              );
            });
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> getNestedRoute(RouteSettings routeSettings) {
    currentRoute = routeSettings.name.toString();
    switch (routeSettings.name) {
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return CupertinoPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text("مسار غير موجود"),
              ),
              body: const Center(child: Text("مسار غير موجود")),
            ));
  }
}

class OtpArguments {
  final String sendTo;
  final bool? init;
  final dynamic Function(String) onSubmit;
  final void Function() onReSend;

  OtpArguments({
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });
}

class NewPasswordArgs {
  final String code;
  final String mobile;
  const NewPasswordArgs({required this.code, required this.mobile});
}

class AboutUsArgs {
  final String title;
  final String type;
  const AboutUsArgs({required this.title, required this.type});
}

class ImageArgs {
  File? image;

  String? url;
  Function(File image, String msgText)? sendFunction;

  ImageArgs({this.image, this.sendFunction, this.url});
}
