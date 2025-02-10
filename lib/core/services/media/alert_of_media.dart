import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/item_of_contact.dart';
import '../../utils/utils.dart';
import '../alerts.dart';

class AlertOfMedia extends StatelessWidget {
  const AlertOfMedia({
    super.key,
    required this.cameraTap,
    required this.galleryTap,
  });

  final void Function(File? image)? cameraTap;
  final void Function(File? image)? galleryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 38, left: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              final File? image = await Utils.myMedia.pickImageFromCamera();
              if (image != null) {
                Navigator.pop(context);

                cameraTap?.call(image);
              } else {
                Navigator.pop(context);
                Alerts.snack(
                    state: SnackState.failed, text: 'No Image Selected');
              }
            },
            child: ItemOfContact(
              title: 'Camera'.tr(),
              choose: false,
              isImage: true,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final File? image = await Utils.myMedia.pickImageFromGallery();
              if (image != null) {
                Navigator.pop(context);

                galleryTap?.call(image);
              } else {
                Navigator.pop(context);
                Alerts.snack(
                    state: SnackState.failed, text: 'No Image Selected');
              }
            },
            child: ItemOfContact(
              title: 'Gallery'.tr(),
              choose: false,
              isImage: true,
            ),
          ),
        ],
      ),
    );
  }
}
