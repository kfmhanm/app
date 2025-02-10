import '../model/my_ads_model.dart';
import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => MyAdsRepository(locator<DioService>()));
//  import '../../modules/my_ads/domain/repository/repository.dart';
class MyAdsRepository {
  final DioService dioService;
  MyAdsRepository(this.dioService);
  Future<PaginatedAds?> getMyAds(page, String type) async {
    final ApiResponse response =
        await dioService.getData(url: "my_ads", query: {
      "page": page,
      "main_type": type,
    });
    if (response.isError == false) {
      return PaginatedAds.fromMap(response.response?.data);
    } else {
      return null;
    }
  }
}
