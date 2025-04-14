import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/features/splash/domain/repository/splash_repository.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/utils.dart';
import '../domain/model/more_model.dart';
import '../domain/repository/repository.dart';
import 'more_states.dart';

class MoreCubit extends Cubit<MoreStates> {
  MoreCubit() : super(MoreInitial());
  static MoreCubit get(context) => BlocProvider.of(context);

  MoreRepository moreRepository = locator<MoreRepository>();
  changePass(String pass, String newPass, String reNewPass) async {
    final response =
        await moreRepository.changePassRequest(pass, newPass, reNewPass);
    if (response != null) {
      return true;
    }
  }

  PagesModel pagesModel = PagesModel();

  pages() async {
    if ((Utils.token.isEmpty == true)) {
      return;
    }
    final response = await moreRepository.pagesRequest();
    if (response != null) {
      pagesModel = PagesModel.fromJson(response);
      emit(MorePagesLoaded());
    }
  }

  deleteAccount() async {
    final response = await moreRepository.deleteAccountRequest();
    if (response != null) {
      await Utils.deleteUserData();
      return true;
    }
  }

  getUserData() async {
    if ((Utils.token.isEmpty == true)) {
      return;
    }
    final response = await locator<SplashRepository>().getProfileRequest();
    if (response != null) {
      // final UserModel user = UserModel.fromJson(response)..token = Utils.token;
      await Utils.saveUserInHive(response);
      return true;
    }
    return null;
  }

  getFavourite() async {
    emit(MoreFavLoading());
    final response = await moreRepository.favourite();
    print(response);
    if (response != null) {
      emit(MoreFavSuccess(response));
    } else {
      emit(MoreFavError());
    }
  }
}
