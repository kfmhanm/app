part of 'nafath_cubit.dart';

@immutable
abstract class NafathState {}

class NafathInitial extends NafathState {}

class NafathChangeAppTheme extends NafathState {}

final class NafathLoginNeedActivateState extends NafathState {}

final class NafathLoginSuccessState extends NafathState {}

final class NafathRecieveTokenfailNafathLoginErrorState extends NafathState {}
final class NafathLoginLoadingState extends NafathState {}

final class NafathRecieveRandomNumberfail extends NafathState {}

final class NafathRecieveRandomNumberSuccessful extends NafathState {}




/*       */
final class NafathRecieveTokenfail extends NafathState {}

final class NafathRecieveTokenSuccessful extends NafathState {}class NafathLoginErrorState extends NafathState {}