import 'package:pride/features/ad_details/domain/model/ad_details_model.dart';

import '../../../core/general/models/user_model.dart';
import '../../home/domain/model/ads_model.dart';

abstract class AdDetailsStates {}

class AdDetailsInitial extends AdDetailsStates {}

class AdDetailsLoading extends AdDetailsStates {}

class AdDetailsSuccess extends AdDetailsStates {
  final AdDetailsModel response;
  AdDetailsSuccess(this.response);
}

class AdDetailsError extends AdDetailsStates {}

class AddCommentError extends AdDetailsStates {}

class AddCommentSuccess extends AdDetailsStates {}

class AdvistorProfileLoading extends AdDetailsStates {}

class AdvistorProfileSuccess extends AdDetailsStates {
  final UserModel response;
  AdvistorProfileSuccess(this.response);
}

class AdvistorProfileError extends AdDetailsStates {}

class SimilarAdLoading extends AdDetailsStates {}

class SimilarAdSuccess extends AdDetailsStates {
  final List<AdsModel> response;
  SimilarAdSuccess(this.response);
}

class SimilarAdError extends AdDetailsStates {}
