part of 'map_brokers_cubit.dart';

@immutable
sealed class MapBrokersState {}

final class MapBrokersInitial extends MapBrokersState {}

class MapsInitial extends MapBrokersState {}

class MapsLoading extends MapBrokersState {}

class MapsSuccess extends MapBrokersState {
  final BrokersModel response;
  MapsSuccess(this.response);
}

class MapsError extends MapBrokersState {}

class Update extends MapBrokersState {}
