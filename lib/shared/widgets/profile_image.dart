import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pride/core/extensions/context_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import 'network_image.dart';

class ProfileImage extends StatefulWidget {
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
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  void didUpdateWidget(covariant ProfileImage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image ||
        oldWidget.imageFile != widget.imageFile ||
        oldWidget.isLocal != widget.isLocal) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.image != null || widget.imageFile != null)
        ? Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.primaryColor, width: 3)),
            child: CircleAvatar(
              radius: (widget.height ?? 50 / 2),
              backgroundImage: widget.isLocal
                  ? Image.file(widget.imageFile!).image
                  : NetworkImagesObject(
                      widget.image ?? "",
                      width: widget.height ?? 30,
                    ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.primaryColor, width: 3),
              color: widget.color,
            ),
            child: SvgPicture.asset(
              "profile".svg(),
              color: widget.colorImage,
              height: widget.height ?? 30,
            ),
          );
  }
}
