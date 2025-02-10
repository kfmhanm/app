import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import '../../../../core/Router/Router.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../domain/model/chats_model.dart';
import '../screens/chat_screen.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    super.key,
    required this.chatModel,
    required this.isMulti,
  });

  final bool isMulti;
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: context.primaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        trailing: CustomText(
          chatModel.createdAt ?? "",
          fontSize: 12,
          color: const Color(0xff727272),
        ),
        onTap: () {
          Navigator.pushNamed(context, Routes.ChatScreen, arguments: {
            "roomId": chatModel.roomId?.toString() ?? "",
            "adId": chatModel.ad_id ?? "",
            "userId": chatModel.user?.id?.toString(),
          });
        },
        title: CustomText(
          isMulti ? chatModel.ad?.title ?? "" : chatModel.user?.name ?? "",
          color: context.secondaryColor,
          fontSize: 14,
          weight: FontWeight.w700,
        ),
        subtitle: CustomText(
          chatModel.file != "" ? "media".tr() : chatModel.message ?? "",
          color: const Color(0xff969696),
          fontSize: 12,
          maxLine: 1,
        ),
        minLeadingWidth: 60,
        leading: ProfileImage(
          image: isMulti ? chatModel.ad?.image ?? "" : chatModel.user?.image,
          color: const Color(0xffF3F3F3),
          colorImage: context.primaryColor,
          height: 30,
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
