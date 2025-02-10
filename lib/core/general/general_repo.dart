import 'package:pride/core/data_source/dio_helper.dart';
import 'package:pride/core/services/alerts.dart';

import '../utils/utils.dart';
import 'models/area_model.dart';
import 'models/feature_model.dart';
import 'models/paged_category_model.dart';

class GeneralRepo {
  final DioService dioService;
  GeneralRepo(this.dioService);
  toggleFavorite(id) async {
    final response = await dioService.putData(
      url: "favourite/$id",
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data["message"], state: SnackState.success);
      return true;
    }
    return response;
  }

  Future<String?> getRoomId({required String brokerId}) async {
    final response = await dioService.getData(
      url: "room/$brokerId",
    );
    if (response.isError == false) {
      return response.response?.data["data"]["room_id"]?.toString();
    }
    return null;
  }

  delete(id) async {
    final response = await dioService.deleteData(
      url: "ads/$id",
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data["message"], state: SnackState.success);
      return true;
    }
    return response;
  }

  deleteAll() async {
    final response = await dioService.deleteData(
      url: "delete_all",
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data["message"], state: SnackState.success);
      return true;
    }
    return response;
  }

  rateAdvistor({
    required double rate,
    required int advistorId,
    int? adId,
  }) async {
    final response = await dioService.postData(
      url: "rates",
      loading: true,
      isForm: true,
      body: {
        "rate": rate,
        "rateable_id": advistorId,
        "ad_id": adId,
      }..removeWhere((key, value) => value == null),
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data["message"], state: SnackState.success);
      return true;
    }
    return response;
  }

  toggleSpecial(id, {required String numberDays}) async {
    final response = await dioService.postData(
      url: "special_ads/$id",
      isForm: true,
      loading: true,
      body: {
        "no_days": numberDays,
      },
    );
    if (response.isError == false) {
      // Alerts.snack(
      //     text: response.response?.data["message"], state: SnackState.success);
      return response.response?.data["data"]["payment_link"];
    }
    return response;
  }

  logout() async {
    final response = await dioService.postData(
        url: "logout", loading: true, body: {"uuid": Utils.uuid}, isForm: true);
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data["message"], state: SnackState.success);
      return true;
    }
    return response;
  }

  Future<PagedCategoriesModel?> getCategories({int? page, String? id}) async {
    final response =
        await dioService.getData(url: "categories", query: {"page": page});
    if (response.isError == false) {
      return PagedCategoriesModel.fromJson(response.response?.data);
    }
    return null;
  }

  Future<PagedCategoriesModel?> getSubCategories(
      {String? id, bool loading = false}) async {
    final response =
        await dioService.getData(url: "categories/$id", loading: loading);
    if (response.isError == false) {
      return PagedCategoriesModel.fromJsonNotPaged(response.response?.data);
    }
    return null;
  }

  Future<PagedAreaModel?> getArea(
      {int? page, String? id, String? search}) async {
    final response = await dioService.getData(
        url: "areas",
        query: {"page": page, "keyword": search}
          ..removeWhere((key, value) => value == null));
    if (response.isError == false) {
      return PagedAreaModel.fromJson(response.response?.data);
    }
    return null;
  }

  Future<PagedAreaModel?> getCities({String? id}) async {
    final response = await dioService.getData(
      url: "areas/$id",
    );
    if (response.isError == false) {
      return PagedAreaModel.fromJsonCities(response.response?.data);
    }
    return null;
  }

  Future<PagedFeatureModel?> getFeaturesAd({
    int? page,
    String? categoryId,
  }) async {
    final response = await dioService.getData(
        url: "features",
        query: {"page": page, "type": "ad", "category_id": categoryId});
    if (response.isError == false) {
      return PagedFeatureModel.fromJson(response.response?.data);
    }
    return null;
  }

  Future<PagedFeatureModel?> getFeaturesCategory({
    int? page,
    String? categoryId,
  }) async {
    final response = await dioService.getData(
        url: "features",
        query: {"page": page, "type": "category", "category_id": categoryId});
    if (response.isError == false) {
      return PagedFeatureModel.fromJson(response.response?.data);
    }
    return null;
  }
}
