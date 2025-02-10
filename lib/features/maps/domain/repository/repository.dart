import '../../../my_ads/domain/model/my_ads_model.dart';
import '../model/brokers_model.dart';

import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => MapsRepository(locator<DioService>()));
//  import '../../modules/maps/domain/repository/repository.dart';
class MapsRepository {
  final DioService dioService;
  MapsRepository(this.dioService);
  Future<PaginatedAds?> getMapAds() async {
    final response = await dioService.getData(
        url: "map_ads", loading: false, query: {"main_type": "normal"});
    if (response.isError == false) {
      return PaginatedAds.WithoutPaged(response.response?.data);
    }
    return null;
  }

  Future<PaginatedAds?> getMapOrder() async {
    final response = await dioService
        .getData(url: "map_ads", loading: false, query: {"main_type": "order"});
    if (response.isError == false) {
      return PaginatedAds.WithoutPaged(response.response?.data);
    }
    return null;
  }

  Future<BrokersModel?> getMapBrokers() async {
    final response = await dioService.getData(
      url: "brokers",
      loading: false,
    );
    if (response.isError == false) {
      return BrokersModel.fromJson(response.response?.data);
    }
    return null;
  }
}
