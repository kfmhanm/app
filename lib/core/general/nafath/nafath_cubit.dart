import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pride/core/services/alerts.dart';
import 'package:pride/core/utils/firebase_message.dart';
import 'package:pride/core/utils/utils.dart';
import 'package:pride/features/auth/domain/repository/auth_repository.dart';

import '../../utils/Locator.dart';

part 'nafath_state.dart';

class NafathCubit extends Cubit<NafathState> {
  NafathCubit() : super(NafathInitial());
  static NafathCubit get(context) => BlocProvider.of(context);

  final AuthRepository nafathRepo = locator<AuthRepository>();
  String? randomNumber;
  loginWithNafat(String NationalId) async {
    emit(NafathLoginLoadingState());
    final response = await nafathRepo.loginWithNafatRequest(NationalId);

    if (response != null) {
      if (response["random"] == null) {
    
        emit(NafathRecieveRandomNumberfail());
        return false;
      } else {
  
        randomNumber = response["random"];
        emit(NafathRecieveRandomNumberSuccessful());
        return true;
      }
    } else {
      emit(NafathLoginErrorState());
      return null;
    }
  }

  loginRequestFromNotification(String token) async {
    final response = await nafathRepo.VerifyloginWithNafatRequest(token);
    log(response.toString(), name: "omar");

    if (response != null) {
      if (response["user"] == null) {
        emit(NafathLoginNeedActivateState());
        return false;
      } else {
        await Utils.saveUserInHive(response);
        await FBMessging.subscripeclient();

        emit(NafathLoginSuccessState());

        return true;
      }
    } else {
      emit(NafathLoginErrorState());
      return null;
    }
  }
  getNafathtoken() async {
    emit(NafathLoginLoadingState());
    final response = await nafathRepo.getNafathtoken();

    if (response != null) {
      if (response["token"] == null) {
    
        emit(NafathRecieveTokenfail());
        return false;
      } else {
  
       
        emit(NafathRecieveTokenSuccessful());
        loginRequestFromNotification(response["token"]);
        return true;
      }
    } else {
      emit(NafathRecieveTokenfail());
      return null;
    }
  }
}
