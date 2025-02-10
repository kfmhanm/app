import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/extentions.dart';
import '../../../../../../core/utils/utils.dart';
import '../../../../../../shared/widgets/customtext.dart';
import '../../../../cubit/splash_cubit.dart';
import '../../../../cubit/splash_states.dart';
import 'dots.dart';

class PageViewWidget extends StatelessWidget {
  const PageViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final cubit = SplashCubit.get(context);
        return Container(
          height: 170,
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.1),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    Utils.onboarding.length,
                    (int index) => DotsWidget(
                      index: index,
                      sliderIndex: cubit.sliderIndex,
                    ),
                  ),
                ),
              ),
              PageView.builder(
                itemCount: Utils.onboarding.length,
                controller: cubit.controller,
                onPageChanged: (index) {
                  cubit.updateSliderIndex(index);
                },
                itemBuilder: (context, index) {
                  final item = Utils.onboarding[index];
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        // 32.ph,
                        CustomText(item.title ?? "".tr(),
                            align: TextAlign.center,
                            color: Colors.white,
                            fontSize: 20,
                            weight: FontWeight.w700),
                        16.ph,
                        CustomText(
                          item.subTitle ?? "".tr(),
                          color: Colors.white,
                          fontSize: 14,
                          weight: FontWeight.w400,
                          align: TextAlign.center,
                        ),
                        // 12.ph
                      ]);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
