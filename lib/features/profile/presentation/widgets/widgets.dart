import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pride/core/extensions/all_extensions.dart';
import 'package:pride/core/utils/extentions.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/services/media/alert_of_media.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/back_widget.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/profile_image.dart';

class AppbarProfile extends StatefulWidget implements PreferredSizeWidget {
  const AppbarProfile({super.key, this.tap});
  final void Function(File? image)? tap;

  @override
  State<AppbarProfile> createState() => _AppbarProfileState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(200);
}

class _AppbarProfileState extends State<AppbarProfile> {
  final formKey = GlobalKey<FormState>();
  File? image;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        280,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            // child: BackWidget(
            //   color: Colors.white,
            // ),
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: const EdgeInsets.only(top: 45),
              child: BackWidget(
                color: Colors.white,
              ),
            ),
          ),
          Column(
            children: [
              60.ph,
              CustomText(
                LocaleKeys.settings_profile.tr(),
                color: Colors.white,
                fontSize: 16.0,
                weight: FontWeight.w700,
              ),
              20.ph,
              Stack(
                children: [
                  ProfileImage(
                    height: 40,
                    image: Utils.userModel.image ?? "",
                    imageFile: image,
                    isLocal: image != null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ).onTap(() async {
                      Alerts.bottomSheet(
                        context,
                        child: AlertOfMedia(
                          cameraTap: (image) {
                            this.image = image;
                            // Navigator.pop(context);
                            widget.tap?.call(image);
                            setState(() {});
                          },
                          galleryTap: (image) {
                            this.image = image;
                            // Navigator.pop(context);
                            widget.tap?.call(image);
                            setState(() {});
                          },
                        ),
                      );
                    }),
                  ),
                ],
              ),
              12.ph,
              CustomText(
                Utils.userModel.name ?? "",
                color: context.primaryColor,
                fontSize: 14.0,
                weight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
