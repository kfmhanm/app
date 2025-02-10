import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/Router/Router.dart';
import 'package:pride/features/create_ad/cubit/create_ad_states.dart';
import 'package:pride/features/create_ad/presentation/screens/create_ad_screen.dart';

import '../../../ad_details/domain/model/ad_details_model.dart';
import '../../cubit/create_ad_cubit.dart';
import 'features_category_screen.dart';
import 'features_screen.dart';

class CreateGeneral extends StatefulWidget {
  const CreateGeneral({super.key, this.adDetailsModel});
  final AdDetailsModel? adDetailsModel;

  @override
  State<CreateGeneral> createState() => _CreateGeneralState();
}

class _CreateGeneralState extends State<CreateGeneral>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.adDetailsModel != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => CreateAdCubit()..initTabBar(this),
        child: BlocConsumer<CreateAdCubit, CreateAdStates>(
          listener: (context, state) {
            if (state is CreateAdSuccess)
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.LayoutScreen, (s) => false,
                  arguments: 1);
          },
          builder: (context, state) {
            final cubit = CreateAdCubit.get(context);
            return WillPopScope(
              onWillPop: () async {
                if (cubit.tabController.index == 0) {
                  Navigator.pop(context);
                } else {
                  cubit.tabController.animateTo(cubit.tabController.index - 1);
                }
                return false;
              },
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: cubit.tabController,
                children: [
                  CreateAdScreen(
                    adDetailsModel: widget.adDetailsModel,
                    cubit: cubit,
                  ),
                  FeaturesScreen(
                    adDetailsModel: widget.adDetailsModel,
                    cubit: cubit,
                  ),
                  FeaturesCategoryScreen(
                    adDetailsModel: widget.adDetailsModel,
                    cubit: cubit,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
