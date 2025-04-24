import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data_source/dio_helper.dart';
import '../../../core/general/models/user_model.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/utils.dart';
import '../domain/repository/repository.dart';
import '../domain/request/profile_request.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);

  ProfileRepository profileRepository =
      ProfileRepository(locator<DioService>());

  editProfile(EditProfileRequest model) async {
    final response = await profileRepository.editProfileRequest(model);
    if (response != null) {
      final res = UserModel.fromJson(response);
      await Utils.saveUserInHive((res..token = Utils.userModel.token).toJson());
      return true;
    }
  }
}
