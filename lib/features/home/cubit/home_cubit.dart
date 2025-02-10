import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/core/general/general_repo.dart';
import '../../../core/utils/Locator.dart';
import '../../my_ads/domain/model/my_ads_model.dart';
import '../domain/model/ads_model.dart';
import '../domain/model/home_model.dart';
import '../domain/repository/repository.dart';
import '../domain/request/home_request.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);

  HomeRepository homeRepository = locator<HomeRepository>();
  void getHome([bool loading = true]
      //{ Map<String, dynamic>? query, }
      ) async {
    if (loading) emit(HomeLoading());
    final response = await homeRepository.getHome(
      query: filterSearch.toMap(),
      loading: !loading,
    );
    if (response != null) {
      emit(HomeSuccess(response));
    } else {
      emit(HomeError());
    }
  }

  FilterSearch filterSearch = FilterSearch();
  List<CategoriesModel>? subCategories = [];
  getSubCategories() async {
    subCategories = (await locator<GeneralRepo>().getSubCategories(
                id: filterSearch.category_id?.toString(), loading: true))
            ?.categories ??
        [];
    emit(HomeSubCategories());
  }

  PagingController<int, AdsModel> myAdscontroller =
      PagingController<int, AdsModel>(firstPageKey: 1);
  addPageoffersLisnter() async {
    myAdscontroller.addPageRequestListener((pageKey) {
      getmyAds(pageKey);
    });
  }

  getmyAds(int page) async {
    final PaginatedAds? res = await homeRepository.getMyAds(
      page,
      filter: filterSearch,
    );
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
}
