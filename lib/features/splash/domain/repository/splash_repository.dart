import '../../../../core/data_source/dio_helper.dart';
import '../model/splash_model.dart';

//put it in locators locator.registerLazySingleton(() => SplashRepository(locator<DioService>()));
//  import '../../modules/splash/domain/repository/repository.dart';
class SplashRepository {
  final DioService dioService;
  SplashRepository(this.dioService);
  Future getProfileRequest() async {
    final response = await dioService.getData(
      url: "profile",
    );
    if (response.isError == false) {
      return response.response?.data['data'];
    } else {
      return null;
    }
  }

  Future<SplashModel?>? getSplash() async {
    final response = await dioService.getData(
      url: "splashes",
    );
    if (response.isError == false) {
      return SplashModel.fromMap(response.response?.data["data"]);
    } else {
      return null;
    }
  }
}
