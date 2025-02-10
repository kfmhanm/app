import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pride/core/data_source/hive_helper.dart';
import 'package:pride/core/general/nafath/nafath_cubit.dart';
import 'core/general/cubit/general_cubit.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';

import 'core/Router/Router.dart';
import 'core/utils/Locator.dart';
import 'core/utils/firebase_message.dart';
import 'core/utils/responsive_framework_widget.dart';
import 'core/utils/utils.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  print(locator.isRegistered<DataManager>()); // Should print true

  await Utils.dataManager.initHive();
  print(locator.isRegistered<DataManager>()); // Should print true

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(
    FBMessging.firebaseMessagingBackgroundHandler,
  );
  // bloc observer
  Bloc.observer = MyBlocObserver();
  // dotenv.load();
  // Utils.getToken();

  runApp(EasyLocalization(
      startLocale: const Locale('ar', 'EG'),
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('en', 'US'),
      ],
      saveLocale: true,
      path: 'assets/translations',
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GeneralCubit(),
          ),
          BlocProvider(
            create: (context) => NafathCubit(),
          ),
        ],
        child: BlocConsumer<GeneralCubit, GeneralState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          // listenWhen: (previous, current)=>cubit. ,
          builder: (context, state) {
            final cubit = GeneralCubit.get(context);
            Utils.lang = context.locale.languageCode;
            return BlocListener<NafathCubit, NafathState>(
              listener: (context, state) {
                if (state is NafathLoginSuccessState) {
                  Navigator.pushNamedAndRemoveUntil(
                      Utils.navigatorKey().currentContext!,
                      Routes.LayoutScreen,
                      (route) => false);
                }
              },
              child: MaterialApp(
                title: 'Vallo',
                themeAnimationDuration: const Duration(milliseconds: 700),
                themeAnimationCurve: Curves.easeInOutCubic,
                navigatorKey: Utils.navigatorKey(),
                debugShowCheckedModeBanner: false,
                locale: context.locale,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                builder: (_, child) {
                  final botToastBuilder = BotToastInit();
                  final smartDialog = FlutterSmartDialog.init();
                  child = smartDialog(context, child);
                  child = botToastBuilder(context, child);
                  SystemChrome.setSystemUIOverlayStyle(
                    cubit.isLightMode
                        ? SystemUiOverlayStyle.dark
                        : SystemUiOverlayStyle.light,
                  );
                  return AppResponsiveWrapper(
                    child: child,
                  );
                },
                onGenerateRoute: RouteGenerator.getRoute,
                // themeMode: cubit.isLightMode ? ThemeMode.light : ThemeMode.dark,
                // theme: cubit.isLightMode ? LightTheme.getTheme() : DarkTheme.getTheme(),
                themeMode: ThemeMode.light,
                theme: LightTheme.getTheme(),
                darkTheme: DarkTheme.getTheme(),
                initialRoute: Routes.splashScreen,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('onEvent -- ${bloc.runtimeType} -- $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType} -- $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('onTransition -- ${bloc.runtimeType} -- $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType} -- $error -- $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    print('onClose -- ${bloc.runtimeType}');
    super.onClose(bloc);
}
}
