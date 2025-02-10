import 'package:pride/features/home/domain/request/home_request.dart';

import '../../../my_ads/domain/model/my_ads_model.dart';
import '../model/home_model.dart';
import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => HomeRepository(locator<DioService>()));
//  import '../../modules/home/domain/repository/repository.dart';
class HomeRepository {
  final DioService dioService;
  HomeRepository(this.dioService);
  Future<HomeModel?> getHome(
      {Map<String, dynamic>? query, bool loading = false}) async {
    final ApiResponse response =
        await dioService.getData(url: "home", query: query, loading: loading);
    if (response.isError == false) {
      return HomeModel.fromJson(response.response?.data["data"]);
    } else {
      return null;
    }
  }

  Future<PaginatedAds?> getMyAds(page, {required FilterSearch filter}) async {
    final ApiResponse response = await dioService
        .getData(url: "ads", query: {"page": page, ...filter.toMap()});
    if (response.isError == false) {
      return PaginatedAds.fromMap(response.response?.data);
    } else {
      return null;
    }
  }
}
