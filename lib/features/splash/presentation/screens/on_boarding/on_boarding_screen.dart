import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/app_strings/locale_keys.dart';

import '../../../../../core/Router/Router.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../cubit/splash_cubit.dart';
import '../../../cubit/splash_states.dart';
import 'widgets/page_view_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late SplashCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = SplashCubit.get(context);
    // Pre-cache the images
    // for (var model in cubit.onboardingModel) {
    //   precacheImage(AssetImage(model.imageUrl), context);
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache the images
    for (var model in Utils.onboarding) {
      precacheImage(NetworkImage(model.imageUrl ?? ""), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashStates>(
      listener: (context, state) {},
      builder: (context, state) {
        print(Utils.onboarding.length);
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(
                  Utils.onboarding[cubit.sliderIndex].imageUrl ?? "",
                ).image,
                fit: BoxFit.cover,
                // filterQuality: FilterQuality.high,
                colorFilter: ColorFilter.mode(
                    Color(0x121212).withOpacity(0.55), BlendMode.darken),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButtonWidget(
                          function: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.LoginScreen, (route) => false);
                          },
                          text: "skip".tr(),
                          fontweight: FontWeight.w400,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 40,
                          child: Divider(
                            color: Colors.white,
                            thickness: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  // 32.ph,
                  Spacer(),
                  const PageViewWidget(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        ButtonWidget(
                          onTap: () {
                            if (cubit.sliderIndex ==
                                Utils.onboarding.length - 1) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.LoginScreen, (roue) => false);
                            } else {
                              cubit.controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.bounceInOut,
                              );
                            }
                          },
                          title:
                              cubit.sliderIndex == Utils.onboarding.length - 1
                                  ? LocaleKeys.onboarding_startNow.tr()
                                  : LocaleKeys.auth_next.tr(),
                        ),
                        GestureDetector(
                          onTap: () {
                            print(cubit.controller.page);
                            if (cubit.sliderIndex ==
                                Utils.onboarding.length - 1) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Routes.LoginScreen, (roue) => false);
                            } else {
                              cubit.controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.bounceInOut,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 22,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.ph,
                  16.ph,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
