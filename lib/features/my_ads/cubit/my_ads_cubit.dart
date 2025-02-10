import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/utils/Locator.dart';
import '../../ad_details/domain/repository/repository.dart';
import '../../home/domain/model/ads_model.dart';
import '../domain/model/my_ads_model.dart';
import '../domain/repository/repository.dart';
import 'my_ads_states.dart';

class MyAdsCubit extends Cubit<MyAdsStates> {
  MyAdsCubit() : super(MyAdsInitial());
  static MyAdsCubit get(context) => BlocProvider.of(context);

  MyAdsRepository my_adsRepository = locator<MyAdsRepository>();
  late TabController tabController;
  initTabController(tracker) async {
    tabController = TabController(length: 2, vsync: tracker, initialIndex: 0);
  }

  PagingController<int, AdsModel> myAdscontroller =
      PagingController<int, AdsModel>(firstPageKey: 1);
  PagingController<int, AdsModel> myOrderscontroller =
      PagingController<int, AdsModel>(firstPageKey: 1);
  addPageoffersLisnter(String type) async {
    myAdscontroller.addPageRequestListener((pageKey) {
      getmyAds(pageKey, type);
    });
  }

  addPageOrderLisnter(String type) async {
    myOrderscontroller.addPageRequestListener((pageKey) {
      getmyOrders(pageKey, type);
    });
  }

  showAd(int id) async {
    final response = await locator<AdDetailsRepository>().showAd(id, true);
    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  getmyAds(int page, String type) async {
    final PaginatedAds? res = await my_adsRepository.getMyAds(page, type);
    if (res != null) {
      var isLastPage = res.page == page;

      if (isLastPage) {
        // stop
        myAdscontroller.appendLastPage(res.myads ?? []);
      } else {
        // increase count to reach new page
        var nextPageKey = page + 1;
        myAdscontroller.appendPage(res.myads ?? [], nextPageKey);
      }
    } else {
      myAdscontroller.error = 'error';
    }
    emit(NewState());
  }

  getmyOrders(int page, String type) async {
    final PaginatedAds? res = await my_adsRepository.getMyAds(page, type);
    if (res != null) {
      var isLastPage = res.page == page;

      if (isLastPage) {
        // stop
        myOrderscontroller.appendLastPage(res.myads ?? []);
      } else {
        // increase count to reach new page
        var nextPageKey = page + 1;
        myOrderscontroller.appendPage(res.myads ?? [], nextPageKey);
      }
    } else {
      myOrderscontroller.error = 'error';
    }
    emit(NewState());
  }
}
