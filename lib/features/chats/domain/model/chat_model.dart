import 'chats_model.dart';

class ChatModel {
  String? id;
  String? roomId;
  User? user;
  String? message;
  String? file;
  String? createdAt;

  ChatModel({
    this.id,
    this.user,
    this.message,
    this.file,
    this.createdAt,
    this.roomId,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    roomId = json['room_id'].toString();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
    file = json['attachment'];
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
