import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:pusher_client/pusher_client.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/utils.dart';
import '../../home/domain/model/ads_model.dart';
import '../domain/model/chats_model.dart';
import '../domain/repository/repository.dart';
import '../domain/request/chats_request.dart';
import 'chats_states.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit() : super(ChatsInitial());
  static ChatsCubit get(context) => BlocProvider.of(context);

  ChatsRepository chatsRepository = locator<ChatsRepository>();
  List<ChatModel> chats = [];

  getChats({required bool multiple}) async {
    emit(ChatsLoading());
    final res = await chatsRepository.getChatsRequest(
      multiple: multiple,
    );
    if (res != null) {
      chats = res.chats ?? [];
      emit(ChatsDone());
    } else {
      emit(ChatsError());
    }
  }

  getMessagesChat({required int page, required String id, String? adId}) async {
    if (page == 1) {
      emit(ChatLoadingState());

      final localMsgs = await Utils.dataManager
          .getMsgs(id, Utils.userModel.id?.toString() ?? "");

      chatController.itemList?.insertAll(0, localMsgs ?? []);
    }

    final res = await chatsRepository.getMessagesChatRequest(
        page: page, id: id, ad_id: adId);

    if (res != null) {
      if (page == 1) {
        user = res.other;
        currentUserId = res.other?.id?.toString() ?? "";
      }
      var isLastPage = res.page == page;
      List<MessageModel>? messages = res.messages;
      if (isLastPage) {
        // stop
        chatController.appendLastPage(messages ?? []);
      } else {
        // increase count to reach new page
        var nextPageKey = page + 1;
        chatController.appendPage(messages ?? [], nextPageKey);
      }
      emit(ChatSuccessState());
      // emit(NewState());
    } else {
      chatController.error = 'error';
      emit(ChatErrorState());
    }
  }

  String currentUserId = '';
  User? user;
  String? roomId;
  addPageLisnterChat(roomid, String? adId) async {
    this.roomId = roomid;
    Utils.room_id = roomid;
    chatController.addPageRequestListener((pageKey) {
      getMessagesChat(page: pageKey, id: roomid, adId: adId);
    });
  }

  Future<MessageModel?> sendMessage(
      MessageModel messageModel, String? adid) async {
    // emit(MessageLoadingState());
    final res =
        await chatsRepository.sendMessageRequest(messageModel..ad_id = adid);
    if (res != null) {
      if (roomId?.isEmpty == true || roomId == null) {
        roomId = res["room_id"]?.toString() ?? "";
        Utils.room_id = roomId ?? "";
        addPageLisnterChat(roomId ?? "", adid);
        initPusher(channelName: roomId ?? "");
      }
      emit(MessageSentState());
      return MessageModel.fromJson(res);
    } else {
      emit(MessageSentErrorState());
      return null;
    }
  }

///////////////////PUSHER/////////////////
  ///private-Chat-
  ///
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onErrorP(String message, int? code, dynamic e) {
    log("onError222: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    log("onEvent: $event");

    String jsonDataString = event.data.toString();
    final jsonData = jsonDecode(jsonDataString)["message"];

    log(event.data.toString() ?? "", name: "pusher event");
    // final data = event?.data ?? "";
    MessageModel message = MessageModel.fromJson(jsonData);
    log((message.id.runtimeType).toString(), name: "dddd");
    if (message.from?.id?.toString() == currentUserId) {
      chatController.itemList?.insert(0, message);

      // log(event?.data.toString() ?? "", name: "h333333333333333");
      emit(ReceivedMessageState());
    }
    // setState(() {
    //   data.add(ChatMessage.fromJson(jsonData['chat']));
    // });
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  // String channelName = "";
  // late Channel channel;
  // late PusherClient pusher = PusherClient(
  //   "eb236294d47f9bae0f2e",
  //   PusherOptions(
  //     encrypted: false,
  //     cluster: "eu",
  //   ),
  // );

  initPusher({required String channelName}) async {
    try {
      await pusher.init(
        apiKey: "eb236294d47f9bae0f2e",
        cluster: "eu",
        onConnectionStateChange: onConnectionStateChange,
        onError: onErrorP,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        // onDecryptionFailure: onDecryptionFailure,
        // onMemberAdded: onMemberAdded,
        // onMemberRemoved: onMemberRemoved,
        // authEndpoint: "<Your Authendpoint>",
        // onAuthorizer: onAuthorizer
      );
      await pusher.subscribe(
        channelName: "Chat-$channelName",
      );
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  ScrollController scrollController = ScrollController();

  PagingController<int, MessageModel> chatController =
      PagingController<int, MessageModel>(firstPageKey: 1);

  final TextEditingController adLocationController = TextEditingController();
  LocationModel locationModel = LocationModel();
  File? image = File("");
  upgradeMemperShip() async {
    // emit(LoadingState());
    final body = MempberShipRequest(
      locationModel: locationModel,
      file: image,
    );
    final res = await chatsRepository.upgradeMemperShip(body);
    if (res != null) {
      locationModel = LocationModel();
      adLocationController.clear();
      image = null;
      return true;
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    if (pusher.connectionState == ConnectionState.done ||
        pusher.connectionState == ConnectionState.active) {
      pusher.disconnect();
    }
    adLocationController.dispose();
    return super.close();
  }
}
