import 'package:pride/core/services/alerts.dart';

import '../request/chats_request.dart';
import 'endpoints.dart';

import '../model/chats_model.dart';
import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => ChatsRepository(locator<DioService>()));
//  import '../../modules/chats/domain/repository/repository.dart';
class ChatsRepository {
  final DioService dioService;
  ChatsRepository(this.dioService);
  Future<PaginationChats?> getChatsRequest({
    required bool multiple,
  }) async {
    final response = await dioService.getData(
      url: "chats",
      query: {
        'multiple': multiple ? "1" : "0",
      },
    );
    if (response.isError == false) {
      return PaginationChats.fromJson(response.response?.data);
    } else {
      return null;
    }
  }

  sendMessageRequest(MessageModel messageModel) async {
    final ApiResponse response = await dioService.postData(
      url: "send_message",
      body: await messageModel.sendMessageJson(),
      isForm: true,
    );

    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  Future<PaginationChat?> getMessagesChatRequest({
    required int page,
    required String id,
    String? ad_id,
  }) async {
    final response = await dioService.getData(
      url: "chat/$id",
      query: {
        'page': page,
        "ad_id": ad_id,
      }..removeWhere((key, value) => value == null || value == "null"),
    );
    if (response.isError == false) {
      return PaginationChat.fromJson(response.response?.data);
    } else {
      return null;
    }
  }

  upgradeMemperShip(MempberShipRequest body) async {
    final response = await dioService.postData(
      url: "agentLicense",
      loading: true,
      isFile: true,
      isForm: true,
      body: await body.toJson(),
    );
    if (response.isError == false) {
      Alerts.snack(
          text: response.response?.data["message"], state: SnackState.success);
      return true;
    } else {
      return null;
    }
  }
}
