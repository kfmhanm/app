import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitial());
  static LayoutCubit get(context) => BlocProvider.of(context);

  LayoutRepository layoutRepository = locator<LayoutRepository>();
  late TabController tabController;

  initTabBar(vsync, [int index = 0]) {
    tabController = TabController(length: 4, vsync: vsync, initialIndex: index);
  }

  void changeTab(int tab) {
    print(tab);
    switch (tab) {
      case 0:
        tabController.animateTo(0);
        break;
      case 1:
        tabController.animateTo(1);
        break;
      case 2:
        tabController.animateTo(2);
        break;
      case 3:
        tabController.animateTo(3);
        break;

      default:
    }
    emit(HomeLayoutChangeScreenState());
  }
}
