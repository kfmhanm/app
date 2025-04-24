import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';
import 'package:pride/features/home/presentation/widgets/widgets.dart';
import 'package:pride/shared/widgets/edit_text_widget.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../shared/widgets/customtext.dart';
import '../../cubit/chats_cubit.dart';
import '../../cubit/chats_states.dart';

class FullImageScreen extends StatefulWidget {
  final String? url;
  final File? photo;
  final Function(File image, String msgText)? sendFunction;
  const FullImageScreen({super.key, this.url, this.photo, this.sendFunction});

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  TextEditingController controller = TextEditingController();
  // PhotoView

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit(),
      child: BlocConsumer<ChatsCubit, ChatsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatsCubit.get(context);
          return Scaffold(
            appBar: const DefaultAppBar(titleAppBar: ''),
            body: widget.url != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: PhotoView(
                      imageProvider:
                          CachedNetworkImageProvider(widget.url ?? ""),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered,
                      initialScale: PhotoViewComputedScale.contained,
                      basePosition: Alignment.center,
                      backgroundDecoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      CustomPhotoViewWidget(
                        photo: widget.photo,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16).copyWith(bottom: 5),
                        child: TextFormFieldWidget(
                          controller: controller,
                          onFieldSubmitted:
                              (value) async {}, // sendMessage(cubit),
                          hintText: 'Type your message'.tr(),
                          // controller: controller,
                          password: false,
                          borderRadius: 33,
                          maxLines: 30,
                          minLines: 1,

                          suffixIcon: SizedBox(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // IconButton(
                                //   onPressed: () {
                                //     chooseMediaSheet(context);
                                //   },
                                //   icon: const Icon(
                                //     Icons.attach_file,
                                //     color: Color(0xff9B9B9B),
                                //   ),
                                // ),
                                GestureDetector(
                                  onTap: () {
                                    widget.sendFunction!(
                                        widget.photo!, controller.text);
                                    // Navigator.pop(context);
                                  },
                                  child: CustomText(
                                    "send".tr(),
                                    color: Colors.white,
                                  ).setContainerToView(
                                      color: context.secondaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8)),
                                ),
                                10.pw,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class CustomPhotoViewWidget extends StatelessWidget {
  const CustomPhotoViewWidget({super.key, this.photo});
  final File? photo;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 750,
      child: PhotoView(
        imageProvider: FileImage(photo ?? File("")),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
