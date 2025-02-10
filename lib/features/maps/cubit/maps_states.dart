import 'package:pride/features/maps/domain/model/maps_model.dart';

import '../../my_ads/domain/model/my_ads_model.dart';

abstract class MapsStates {}

class MapsInitial extends MapsStates {}

class MapsLoading extends MapsStates {}

class MapsSuccess extends MapsStates {
  final PaginatedAds response;
  MapsSuccess(this.response);
}

class MapsError extends MapsStates {}

class Update extends MapsStates {}
