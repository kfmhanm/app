import 'package:animated_widgets_flutter/widgets/opacity_animated.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../cubit/splash_cubit.dart';
import '../../../cubit/splash_states.dart';

///// put it in routes
///  import '../../modules/splash/presentation/splash.dart';
/// static const String splashScreen = "/splashScreen";

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SplashCubit(),
        child: Scaffold(
          body: BlocConsumer<SplashCubit, SplashStates>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              final cubit = SplashCubit.get(context);
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: OpacityAnimatedWidget.tween(
                      opacityEnabled: 1,
                      opacityDisabled: 0,
                      duration: const Duration(milliseconds: 3000),
                      enabled: true,
                      animationFinished: (finished) async {
                        final isLogin = await cubit.checkLogin();
                        // Navigator.pushNamed(context, Routes.OnboardingScreen);
                        Navigator.pushNamedAndRemoveUntil(
                            context, isLogin, (route) => false);
                      },
                      child: Image.asset(
                        "logo".png("icons"),
                        scale: 2,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Image.asset(
                      "background".png(),
                      scale: 1.5,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
