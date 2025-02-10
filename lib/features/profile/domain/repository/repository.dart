import '../../../../core/services/alerts.dart';
import '../request/profile_request.dart';

import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => ProfileRepository(locator<DioService>()));
//  import '../../modules/profile/domain/repository/repository.dart';
class ProfileRepository {
  final DioService dioService;
  ProfileRepository(this.dioService);
  editProfileRequest(EditProfileRequest model) async {
    final response = await dioService.postData(
        isFile: true,
        isForm: true,
        url: "profile/edit",
        loading: true,
        body: await model.toMap());

    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data?["message"], state: SnackState.success);
      return response.response?.data?["data"];
    } else {
      return null;
    }
  }
}
