import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/services/media/alert_of_media.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';
import '../../../../shared/widgets/loadinganderror.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../cubit/chats_cubit.dart';
import '../../cubit/chats_states.dart';
import '../../domain/model/chats_model.dart';
import '../widgets/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.roomId, this.adId, this.userId, this.username});
  final String roomId;
  final String? adId;
  final String? userId;
  final String? username;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message = "";
  TextEditingController messageField = TextEditingController();
  late MessageModel msg;

  @override
  void initState() {
    print(widget.roomId);
    // Utils.room_id = widget.roomId;
    super.initState();
  }

  Future<void> sendMessage(
    ChatsCubit cubit, [
    File? file,
  ]) async {
    if (messageField.text.trim().isNotEmpty || file != null) {
      message = messageField.text;
      messageField.clear();
      msg = MessageModel(
        toId: cubit.user?.id?.toString() ?? widget.userId ?? "",
        message: message.isEmpty ? "" : message,
        fromme: true,
        // from: null,
        // to: null,
        // id: null,
        file: file,
        roomId: widget.roomId.toInt(),
        fromId: Utils.userModel.id?.toString() ?? "",
        createdAt: DateTime.now().toLocal().toString(),
        attachment: "",
      );
      messageField.clear();
      // if(cubit.roomId?.isEmpty == true){
      //   cubit.roomId = widget.roomId;
      // }
      print("cubitroomId ${cubit.roomId}");
      if (cubit.roomId?.isEmpty == true || cubit.roomId == null) {
        await cubit.sendMessage(msg, widget.adId);
        return;
      }

      cubit.chatController.itemList?.insert(0, msg);
      cubit.scrollController.jumpTo(cubit.scrollController.initialScrollOffset);
      setState(() {});
    }
  }

  // setState(() {});

  void chooseMediaSheet(BuildContext context, ChatsCubit cubit) {
    Alerts.bottomSheet(
      context,
      child: AlertOfMedia(
        cameraTap: (image) {
          Navigator.pushNamed(
            context,
            Routes.imageFullScreen,
            arguments: ImageArgs(
              image: image,
              sendFunction: (image, text) async {
                Navigator.pop(context);
                messageField.text = text;
                sendMessage(cubit, image);
              },
            ),
          );
        },
        galleryTap: (image) async {
          Navigator.pushNamed(
            context,
            Routes.imageFullScreen,
            arguments: ImageArgs(
              image: image,
              sendFunction: (image, text) async {
                Navigator.pop(context);
                messageField.text = text;
                sendMessage(cubit, image);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    Utils.room_id = "";
    RouteGenerator.currentRoute = "";
    messageField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("widget.roomId ${widget.roomId}");
    // print("widget.adId ${widget.adId}");
    return BlocProvider(
      create: (context) {
        return (widget.roomId.isEmpty)
            ? ChatsCubit()
            : (ChatsCubit()
              ..addPageLisnterChat(widget.roomId, widget.adId)
              ..initPusher(channelName: widget.roomId));
      },
      child: BlocConsumer<ChatsCubit, ChatsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatsCubit.get(context);
          return Scaffold(
            body: LoadingAndError(
              isError: state is ChatErrorState,
              isLoading: state is ChatLoadingState,
              function: () => cubit
                ..addPageLisnterChat(widget.roomId, widget.adId)
                ..initPusher(channelName: widget.roomId),
              child: Scaffold(
                appBar: DefaultAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: ListTile(
                          horizontalTitleGap: 8,
                          leading: ProfileImage(
                            image: cubit.user?.image ?? "",
                          ),
                          contentPadding: EdgeInsets.zero,
                          title: CustomText(
                            overflow: TextOverflow.ellipsis,
                            cubit.user?.name ?? widget.username ?? "",
                            weight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: (widget.roomId.isEmpty == true &&
                              cubit.roomId == null)
                          ? EmptyWidget(
                              image: "sms",
                              color: Color(0xffBEBEBE),
                              title: LocaleKeys.no_msg,
                              subtitle: LocaleKeys.no_msg_you,
                            )
                          : PagedListView.separated(
                              scrollController: cubit.scrollController,
                              reverse: true,
                              pagingController: cubit.chatController,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              builderDelegate:
                                  PagedChildBuilderDelegate<MessageModel>(
                                itemBuilder: (context, item, i) {
                                  return CustomMessageWidget(
                                    item: item,
                                    adId: widget.adId,
                                    key: ValueKey("$i${item.createdAt}"),
                                  );
                                },
                                noItemsFoundIndicatorBuilder: (_) =>
                                    EmptyWidget(
                                  image: "sms",
                                  color: Color(0xffBEBEBE),
                                  title: LocaleKeys.no_msg,
                                  subtitle: LocaleKeys.no_msg_you,
                                ),
                              ),
                              separatorBuilder: (_, i) => Divider(
                                color: const Color(0xff707070).withOpacity(.13),
                                thickness: 1,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16).copyWith(bottom: 5),
                      child: TextFormFieldWidget(
                        controller: messageField,
                        onFieldSubmitted: (value) async {
                          await sendMessage(
                            cubit,
                          );
                          messageField.clear();
                        },
                        hintText: 'Type your message'.tr(),
                        password: false,
                        maxLines: 30,
                        minLines: 1,
                        borderRadius: 10,
                        suffixIcon: SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  chooseMediaSheet(context, cubit);
                                },
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: Color(0xff9B9B9B),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await sendMessage(
                                    cubit,
                                  );
                                  messageField.clear();
                                },
                                child: CustomText(
                                  "send".tr(),
                                  color: Colors.white,
                                ).setContainerToView(
                                    color: Color(0xff27AD38),
                                    borderRadius: BorderRadius.circular(10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 17.1, vertical: 14)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    this.color,
    this.colorImage,
    this.image,
    this.imageFile,
    this.height,
    this.isLocal = false,
  });

  final Color? color, colorImage;
  final double? height;
  final String? image;
  final File? imageFile;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    return image != null && image != ""
        ? CircleAvatar(
            radius: (height ?? 50 / 2),
            backgroundImage: isLocal
                ? Image.file(imageFile!).image
                : NetworkImagesObject(
                    image ?? "",
                    width: height ?? 30,
                  ),
          )
        : Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: SvgPicture.asset(
              "profile".svg(),
              color: colorImage,
              height: height ?? 30,
            ),
          );
  }
}
