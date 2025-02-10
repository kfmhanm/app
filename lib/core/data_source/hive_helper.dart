import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// import '../../modules/auth/domain/model/auth_model.dart';
import '../../features/chats/domain/model/chats_model.dart';
import '../utils/utils.dart';

class DataManager {
  late BoxCollection collection;
  late Box userData;

  static const USER = "USER";

  Future initHive() async {
    await Hive.initFlutter();
    userData = await Hive.openBox('dataUser');
    localMessage = await Hive.openBox("dataMessages");

    // final directory = await getApplicationDocumentsDirectory();
    // collection = await BoxCollection.open(
    //   'dataManager', // Name of your database
    //   {'data'}, // Names of your boxes
    //   path: directory
    //       .path, // Path where to store your boxes (Only used in Flutter / Dart IO)
    // );
  }

  Future<void> saveData(String key, dynamic value) async {
     Box   box = await Hive.openBox("data");

    await box.put(key, value);
     box.close();
  }

  saveUser(Map<String, dynamic> value) async {
    // await Hive.initFlutter();
    // final userData = await Hive.openBox('dataUser');
    await userData.put(USER, value);
    // userData.close();
  }

  Future<String?> getData(String key) async {
     Box   box = await Hive.openBox("data");

    final data = await box.get(key);
         box.close();

    return data?.toString() ?? null; // Ensure it returns a String, even if null
  }

  Future getUserData() async {
    // final userData = await Hive.openBox('dataUser');

    try {
      final user = (Map<String, dynamic>.from(await userData.get(USER)));

      Utils.token = user['access_token'];

      log("tokennnnnnn ${Utils.token}");
      log("toke  ${user['access_token']}");
      log(Utils.token);

      // Utils.userModel = UserModel.fromJson(Map<String, dynamic>.from(user));

      return userData.get(USER);
    } catch (e) {
      log(e.toString());
      //  userData.clear();
    }
  }

  Future deleteUserData() async {
    // final userData = await Hive.openBox('dataUser');

    return userData.delete(USER);
  }

  deleteAllData() async {
    final userData = await Hive.openBox('data');

    return userData.delete(USER);
  }

  deleteData(String key) async {
    final userData = await Hive.openBox('data');

    return userData.delete(key);
  }

  late Box localMessage;
  deleteAllMsgs() async => await localMessage.clear();

  addMsg(
    MessageModel message,
  ) async =>
      await localMessage.put(message.createdAt, await message.msgSave());

  deleteMsg(String key) async => await localMessage.delete(key);

  updateMsg(String key, MessageModel msg) async =>
      await localMessage.put(key, await msg.msgSave());

  // Future<MessageModel> getMessage(String key) async =>
  //     MessageModel.fromHive(await localMessage.get(key));

  //  ;
  Future<List<MessageModel>?> getMsgs(String roomId, String FromId) async {
    List<MessageModel> messsages = [];
    for (Map element in localMessage.values) {
      final message = MessageModel.fromHive(element);
      if (message.fromId == FromId && message.roomId == roomId) {
        messsages.add(message);
      }
    }
    return messsages.reversed.toList();
  }
}
