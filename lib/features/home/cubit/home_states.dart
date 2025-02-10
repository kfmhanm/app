import 'package:pride/features/home/domain/model/home_model.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class HomeLoading extends HomeStates {}

class HomeSuccess extends HomeStates {
  final HomeModel response;
  HomeSuccess(this.response);
}

class HomeError extends HomeStates {}

class HomeSubCategories extends HomeStates {}

class NewState extends HomeStates {}
