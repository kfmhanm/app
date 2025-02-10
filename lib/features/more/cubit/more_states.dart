import 'package:pride/features/home/domain/model/ads_model.dart';

abstract class MoreStates {}

class MoreInitial extends MoreStates {}

class MoreLoading extends MoreStates {}

class MoreSuccess extends MoreStates {}

class MoreError extends MoreStates {}

class MoreFavLoading extends MoreStates {}

class MorePagesLoaded extends MoreStates {}

class MoreFavSuccess extends MoreStates {
  final List<AdsModel> response;
  MoreFavSuccess(this.response);
}

class MoreFavError extends MoreStates {}
