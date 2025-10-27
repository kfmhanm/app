import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/Router/Router.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/chats/presentation/screens/chats_screen.dart';

import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/login_dialog.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../more/presentation/screens/more_screen.dart';
import '../../../my_ads/presentation/screens/my_ads_screen.dart';
import '../../cubit/layout_cubit.dart';
import '../../cubit/layout_states.dart';
import '../widgets/widgets.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.index});

  final int? index;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Utils.nafathtoken = null;
    Utils.dataManager.deleteData('nafathtoken');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..initTabBar(this, widget.index ?? 0),
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = LayoutCubit.get(context);
          return Scaffold(
            body: TabBarView(
              controller: cubit.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomeScreen(),
                (Utils.token.isNotEmpty == true)
                    ? MyAdsScreen()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "logo".png("icons"),
                            scale: 2,
                          ),
                          const Center(child: LoginDialog()),
                        ],
                      ),
                (Utils.token.isNotEmpty == true)
                    ? ChatsScreen()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "logo".png("icons"),
                            scale: 2,
                          ),
                          const Center(child: LoginDialog()),
                        ],
                      ),
                // (Utils.token.isNotEmpty == true)
                true
                    ? MoreScreen()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "logo".png("icons"),
                            scale: 2,
                          ),
                          const Center(child: LoginDialog()),
                        ],
                      ),
                /*     Container(
                  child: Center(
                    child: ButtonWidget(
                      title: "Logout",
                      onTap: () {
                        Utils.logout();
                      },
                    ),
                  ),
                ), */
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: (Utils.token.isNotEmpty == true &&
                    /*   Utils.userModel.type == "broker" && */
                    cubit.tabController.index == 1)
                ? Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: context.primaryColor, width: 2),
                    ),
                    child: FloatingActionButton(
                      backgroundColor: context.primaryColor,
                      shape: CircleBorder(),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.AdValidationScreen);
                      },
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: cubit.tabController.index,
              onTap: cubit.changeTab,
            ),
            extendBody: true,
          );
        },
      ),
    );
  }
}
