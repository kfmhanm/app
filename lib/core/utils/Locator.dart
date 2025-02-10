import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pride/core/general/general_repo.dart';
import 'package:pride/features/home/domain/repository/repository.dart';
import '../../core/utils/validations.dart';
import '../../features/ad_details/domain/repository/repository.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/chats/domain/repository/repository.dart';
import '../../features/create_ad/domain/repository/repository.dart';
import '../../features/layout/domain/repository/repository.dart';
import '../../features/maps/domain/repository/repository.dart';
import '../../features/more/domain/repository/repository.dart';
import '../../features/my_ads/domain/repository/repository.dart';
import '../../features/notifications/domain/repository/repository.dart';
import '../../features/splash/domain/repository/splash_repository.dart';
import '../../features/static_page/domain/repository/repository.dart';
import '../Router/Router.dart';
import '../config/key.dart';
import '../data_source/dio_helper.dart';
import '../data_source/hive_helper.dart';
import '../services/media/my_media.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
    locator.registerLazySingleton(() => DataManager());

  locator.registerLazySingleton(() => DioService(ConstKeys.baseUrl));
  locator.registerLazySingleton(() => Routes());
  locator.registerLazySingleton(() => Validation());
  locator.registerLazySingleton(() => MyMedia());
  locator.registerLazySingleton(() => GlobalKey<ScaffoldState>());
  locator.registerLazySingleton(() => GlobalKey<NavigatorState>());
  locator.registerLazySingleton(() => AuthRepository(locator<DioService>()));
  locator.registerLazySingleton(() => SplashRepository(locator<DioService>()));
  locator.registerLazySingleton(() => GeneralRepo(locator<DioService>()));
  locator.registerLazySingleton(() => HomeRepository(locator<DioService>()));
  locator.registerLazySingleton(() => LayoutRepository(locator<DioService>()));
  locator.registerLazySingleton(() => MyAdsRepository(locator<DioService>()));
  locator.registerLazySingleton(() => MoreRepository(locator<DioService>()));
  locator.registerLazySingleton(() => ChatsRepository(locator<DioService>()));
  locator.registerLazySingleton(() => MapsRepository(locator<DioService>()));
  locator
      .registerLazySingleton(() => StaticPageRepository(locator<DioService>()));
  locator
      .registerLazySingleton(() => CreateAdRepository(locator<DioService>()));
  locator.registerLazySingleton(
      () => NotificationsRepository(locator<DioService>()));
  locator
      .registerLazySingleton(() => AdDetailsRepository(locator<DioService>()));
}
