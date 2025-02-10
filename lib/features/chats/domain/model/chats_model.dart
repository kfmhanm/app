import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pride/features/ad_details/domain/model/ad_details_model.dart';

import '../../../../core/general/models/user_model.dart';
import '../../../../core/utils/Utils.dart';
import '../../../home/domain/model/home_model.dart';

class ChatModel {
  String? id;
  bool? is_readed;
  bool? fromme;
  String? roomId;
  User? user;
  ADModel? ad;
  String? message;
  String? ad_id;
  String? file;
  String? createdAt;

  ChatModel({
    this.id,
    this.fromme,
    this.ad_id,
    this.ad,
    this.user,
    this.is_readed,
    this.message,
    this.file,
    this.createdAt,
    this.roomId,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    roomId = json['room_id'].toString();
    ad_id = json['ad_id'].toString();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    ad = json['ad'] != null ? ADModel.fromJson(json['ad']) : null;
    message = json['message'];
    file = json['attachment'];
    fromme = json['fromme'];
    is_readed = json['is_readed'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['message'] = message;
    data['room_id'] = roomId;
    data['attachment'] = file;
    data['created_at'] = createdAt;
    return data;
  }
}

class User extends UserModel {
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
  }
}

class ADModel extends AdDetailsModel {
  String? areaName;
  ADModel({this.areaName});
  ADModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    areaName = json['area'];
  }
}

class PaginationChats {
  List<ChatModel>? chats;
  // int? page;
  PaginationChats({this.chats});
  PaginationChats.fromJson(Map<String, dynamic> json) {
    // page = json['pagination']['lastPage'];

    if (json['data'] != null) {
      chats = <ChatModel>[];
      json['data'].forEach((v) {
        chats!.add(ChatModel.fromJson(v));
      });
      // chats = chats?.reversed.toList();
    }
  }
}

class PaginationChat {
  List<MessageModel>? messages;
  User? other;
  int? page;
  PaginationChat({this.messages});
  PaginationChat.fromJson(Map<String, dynamic> json) {
    page = json['pagination']['lastPage'];

    if (json['data']["messages"] != null) {
      messages = <MessageModel>[];
      json['data']["messages"].forEach((v) {
        messages!.add(MessageModel.fromJson(v));
      });
    }
    if (json['data']["other"] != null) {
      other = User.fromJson(json['data']["other"]);
    }
  }
}

class MessageModel {
  int? id;
  From? from;
  bool isLoading = false;
  bool? fromme;
  bool? faildToSent;
  int? roomId;
  From? to;
  String? message;
  File? file;
  String? createdAt;
  String? ad_id;
  String? toId;
  String? attachment;

  String? fromId;

  MessageModel(
      {this.id,
      this.from,
      this.to,
      this.fromme,
      this.message,
      this.faildToSent = false,
      this.createdAt,
      this.attachment,
      this.ad_id,
      this.toId,
      this.file,
      this.fromId,
      this.roomId});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromme = json['fromme'];
    attachment = json['attachment'];
    roomId = json['room_id'];

    from = json['from'] != null ? From.fromJson(json['from']) : null;
    to = json['to'] != null ? From.fromJson(json['to']) : null;
    message = json['message'];
    // file = json['file'];
    createdAt = json['created_at'];
    fromId = from?.id?.toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attachment'] = attachment;
    data['to_id'] = toId;
    data['room_id'] = roomId;
    if (from != null) {
      data['from'] = from!.toJson();
    }
    if (to != null) {
      data['to'] = to!.toJson();
    }
    data['message'] = message;
    // data['file'] = file;
    data['created_at'] = createdAt;
    return data;
  }

  Future<Map<String, dynamic>> sendMessageJson() async {
    log("file: ${ad_id}");
    final Map<String, dynamic> data = <String, dynamic>{};
    data["to_id"] = toId;
    if (ad_id != "null" && ad_id != null) data["ad_id"] = ad_id;
    data['message'] = message;
    if (file != null) {
      data['file'] = await MultipartFile.fromFile(file!.path,
          filename: file!.path.split(Platform.pathSeparator).last);
    }
    return data;
  }

  Future<Map<String, dynamic>> msgSave() async {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    data['room_id'] = roomId;
    data["from_id"] = Utils.userModel.id;
    data['to'] = to;
    data['created_at'] = createdAt;
    if (file != null) data['imagePath'] = file?.path;

    return data;
  }

  MessageModel.fromHive(Map json) {
    from?.id = json['from_id'];
    message = json['message'];

    to = json['to'];
    roomId = json['room_id'];
    createdAt = json['created_at'];

    if (json['imagePath'] != null) file = File(json['imagePath']);
  }
}

class From extends UserModel {
  From.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
