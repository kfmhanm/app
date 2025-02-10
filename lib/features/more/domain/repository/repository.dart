import '../../../../core/services/alerts.dart';

import '../../../../core/data_source/dio_helper.dart';
import '../../../home/domain/model/ads_model.dart';

//put it in locators locator.registerLazySingleton(() => MoreRepository(locator<DioService>()));
//  import '../../modules/more/domain/repository/repository.dart';
class MoreRepository {
  final DioService dioService;
  MoreRepository(this.dioService);
  changePassRequest(String pass, String newPass, String reNewPass) async {
    final response = await dioService.postData(
        url: "profile/change_password",
        isForm: true,
        loading: true,
        body: {
          "old_password": pass,
          "new_password": newPass,
          "new_password_confirmation": reNewPass
        });

    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data?["message"], state: SnackState.success);
      return true;
    } else {
      return null;
    }
  }

  pagesRequest() async {
    final response = await dioService.getData(
      url: "pages",
      loading: true,
    );
    if (response.isError == false) {
      return response.response?.data;
    } else {
      return null;
    }
  }

  Future contact() async {
    final respose = await dioService.getData(url: "socials", loading: false);
    if (respose.isError == false) {
      return respose.response?.data['data'];
    }
  }

  favourite() async {
    final respose = await dioService.getData(
      url: "favourite",
    );
    if (respose.isError == false) {
      // convert the response to a list of models
      List<AdsModel> data = [];
      respose.response?.data['data']['favourites'].forEach((e) {
        data.add(AdsModel.fromJson(e));
      });

      return data;
    }
  }

  deleteAccountRequest() async {
    final response =
        await dioService.deleteData(url: "delete_account", loading: true);
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data?["message"], state: SnackState.success);
      return true;
    } else {
      return null;
    }
  }
}
