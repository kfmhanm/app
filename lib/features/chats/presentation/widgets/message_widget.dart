import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pride/core/Router/Router.dart';
import 'package:pride/core/extensions/context_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/core/utils/utils.dart';
import 'package:pride/shared/widgets/customtext.dart';
import 'package:pride/shared/widgets/network_image.dart';

import '../../cubit/chats_cubit.dart';
import '../../domain/model/chats_model.dart';

class CustomMessageWidget extends StatefulWidget {
  const CustomMessageWidget({
    super.key,
    this.item,
    this.adId,
  });
  final MessageModel? item;
  final String? adId;

  @override
  State<CustomMessageWidget> createState() => _CustomMessageWidgetState();
}

class _CustomMessageWidgetState extends State<CustomMessageWidget> {
  ChatsCubit? cubit;
  @override
  void initState() {
    cubit = ChatsCubit.get(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await sendMsg();
    });

    super.initState();
  }

  Future<void> sendMsg() async {
    if (widget.item?.id == null && widget.item?.isLoading == false) {
      widget.item?.isLoading = true;
      widget.item?.faildToSent = false;

      await Utils.dataManager.addMsg(
        widget.item!,
      );
      MessageModel? send = await cubit?.sendMessage(widget.item!, widget.adId);

      // widget.item?.isLoading = false;
      widget.item?.isLoading = false;
      widget.item?.id = send?.id;
      widget.item?.attachment = send?.attachment;
      widget.item?.faildToSent = false;
      await Utils.dataManager.deleteMsg(widget.item?.createdAt ?? '');

      widget.item?.createdAt = send?.createdAt;
      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 4, bottom: 4),
      child: Align(
        alignment: widget.item?.fromme == true
            ? Alignment.topRight
            : Alignment.topLeft,
        child: Row(
          mainAxisAlignment: widget.item?.fromme == true
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.item?.id == null && widget.item?.faildToSent == true)
              IconButton(
                  onPressed: () async {
                    await sendMsg();
                  },
                  icon: Icon(
                    Icons.replay,
                    color: Colors.red,
                  )),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .6),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                color: widget.item?.fromme == true
                    ? Color(0xffD9D9D9)
                    : context.primaryColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((widget.item?.attachment != "" &&
                          widget.item?.attachment != null) ||
                      widget.item?.file != null)
                    Column(
                      children: [
                        widget.item?.id == null
                            ? Image.file(
                                widget.item?.file ?? File(""),
                                height: 200,
                                width: MediaQuery.sizeOf(context).width * .7,
                                fit: BoxFit.fitWidth,
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.imageFullScreen,
                                      arguments: ImageArgs(
                                        url: widget.item!.attachment,
                                      ));
                                },
                                child: NetworkImagesWidgets(
                                  widget.item?.attachment ?? "",
                                  height: 200,
                                  width: MediaQuery.sizeOf(context).width * .7,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                        8.ph
                      ],
                    ),
                  // if (isLoading) const CircularProgressIndicator(),
                  CustomText(
                    widget.item?.message ?? "",
                    // fontSize: 14,
                    // weight: FontWeight.w300,
                    color: widget.item?.fromme == true
                        ? Color(0xff818181)
                        : Colors.white,
                  ),
                ],
              ),
            ),
            if (widget.item?.fromme == true) ...[
              4.pw,
              if (widget.item?.id == null)
                const Icon(
                  Icons.av_timer_rounded,
                  size: 15,
                ),
              if (widget.item?.id != null)
                const Icon(
                  Icons.check,
                  size: 15,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
