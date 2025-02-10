import 'package:pride/core/general/models/user_model.dart';

import '../../../home/domain/model/ads_model.dart';
import '../model/paged_comment_model.dart';
import 'endpoints.dart';

import '../model/ad_details_model.dart';
import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => AdDetailsRepository(locator<DioService>()));
//  import '../../modules/ad_details/domain/repository/repository.dart';
class AdDetailsRepository {
  final DioService dioService;
  AdDetailsRepository(this.dioService);
  Future<AdDetailsModel?> showAd(int id, [bool loading = false]) async {
    final response = await dioService.getData(
      url: "ads/$id",
      loading: loading,
    );
    if (response.isError == false) {
      return AdDetailsModel.fromJson(response.response?.data["data"]);
    }
    return null;
  }

  addComment(int id, String comment) async {
    final response = await dioService.postData(
        url: "comments",
        body: {"comment": comment, "ad_id": id},
        isForm: true,
        loading: true);
    if (response.isError == false) {
      return true;
    }
    return null;
  }

  Future<PagedCommentModel?> getComments(
    int id,
    int page,
  ) async {
    final response = await dioService.getData(
      url: "comments",
      query: {"ad_id": id, "page": page},
    );
    if (response.isError == false) {
      return PagedCommentModel.fromJson(response.response?.data);
    }
    return null;
  }

  Future<List<AdsModel>?> getAds(
    int id,
  ) async {
    final response = await dioService.getData(
      url: "ads/$id/similar",
    );
    if (response.isError == false) {
      return PagedAdsModel.fromJson(response.response?.data).ads;
    }
    return null;
  }

  getAdvistorProfile(
    int id,
  ) async {
    final response =
        await dioService.getData(url: "profile/$id", loading: true);
    if (response.isError == false) {
      return UserModel.fromJson(response.response?.data["data"]);
    }
    return null;
  }

  startChat(String brokerId) async {
    final response = await dioService.postData(
        url: "brokers/startChat/$brokerId", loading: true, isForm: true);
    if (response.isError == false) {
      return response.response?.data["data"]["link"];
    }
    return null;
  }
}
