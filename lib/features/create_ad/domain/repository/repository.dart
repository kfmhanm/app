import 'package:pride/features/create_ad/domain/request/create_ad_request.dart';

import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => CreateAdRepository(locator<DioService>()));
//  import '../../modules/create_ad/domain/repository/repository.dart';
class CreateAdRepository {
  final DioService dioService;
  CreateAdRepository(this.dioService);
  createAd(CreateAdRequest ad) async {
    final response = await dioService.postData(
        url: "ads",
        body: await ad.toMap(),
        loading: true,
        isFile: true,
        isForm: true);
    if (response.isError == false) {
      return true;
    }
    return false;
  }

  update(CreateAdRequest ad, int id) async {
    final response = await dioService.postData(
        url: "ads/$id",
        body: await ad.toEdit(),
        isFile: true,
        loading: true,
        isForm: true);
    if (response.isError == false) {
      return true;
    }
    return false;
  }

  deleteImage(String adId, String imageId) async {
    final response = await dioService.deleteData(
        url: "deleteImage/$adId/$imageId", loading: true);
    if (response.isError == false) {
      return true;
    }
    return false;
  }
}
