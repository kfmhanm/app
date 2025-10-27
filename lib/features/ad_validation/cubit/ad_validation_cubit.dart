import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/model/ad_validation_model.dart';
import '../domain/repository/ad_validation_repository.dart';
import 'ad_validation_states.dart';

class AdValidationCubit extends Cubit<AdValidationStates> {
  AdValidationCubit() : super(AdValidationInitial());
  
  static AdValidationCubit get(context) => BlocProvider.of(context);

  final AdValidationRepository _repository = AdValidationRepository();
  AdValidationResponse? validationResponse;

  Future<void> validateAd({
    required String adLicenseNumber,
    required String advertiserId,
    int idType = 2,
  }) async {
    emit(AdValidationLoading());
    
    try {
      validationResponse = await _repository.validateAd(
        adLicenseNumber: adLicenseNumber,
        advertiserId: advertiserId,
        idType: idType,
      );

      // Check if the response contains an error
      if (validationResponse?.body?.error != null) {
        emit(AdValidationFailed(
          validationResponse?.body?.error?.message ?? 'حدث خطأ ما'
        ));
        return;
      }

      // Check if validation is successful
      if (validationResponse?.body?.result?.isValid == true) {
        emit(AdValidationSuccess());
      } else {
        emit(AdValidationFailed(
          validationResponse?.body?.result?.message ?? 'التحقق من الإعلان فشل'
        ));
      }
    } catch (e) {
      emit(AdValidationFailed('حدث خطأ أثناء التحقق: ${e.toString()}'));
    }
  }

  void reset() {
    validationResponse = null;
    emit(AdValidationInitial());
  }
}


