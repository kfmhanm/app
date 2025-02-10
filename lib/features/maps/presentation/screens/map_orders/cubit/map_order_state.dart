part of 'map_order_cubit.dart';

@immutable
sealed class MapOrderState {}

final class MapOrderInitial extends MapOrderState {}

class MapsInitial extends MapOrderState {}

class MapsLoading extends MapOrderState {}

class MapsSuccess extends MapOrderState {
  final PaginatedAds response;
  MapsSuccess(this.response);
}

class MapsError extends MapOrderState {}

class Update extends MapOrderState {}
