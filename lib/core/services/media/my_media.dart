import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../shared/widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

import '../../../shared/widgets/button_widget.dart';
import '../../utils/utils.dart';
import '../alerts.dart';

class MyMedia {
  static final ImagePicker _picker = ImagePicker();

  Future<Uint8List> generateVideoThumbnail(
      {File? file, String url = ''}) async {
    final thumbnailPath = await VideoThumbnail.thumbnailData(
      video: file != null ? file.path : url,
      imageFormat: ImageFormat.PNG,
      maxHeight: 80,
      maxWidth: 80,
      quality: 75,
    );
    return thumbnailPath!;
  }

  static Future<List<File>?> pickImages({bool isMultiple = true}) async {
    List<XFile?>? images = [];

    try {
      if (isMultiple) {
        images = await _picker.pickMultiImage();
      } else {
        images = [
          await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 100,
            maxWidth: 1080,
          )
        ];
      }
      List<File>? imageFiles =
          images.map<File>((xfile) => File(xfile?.path ?? "")).toList();
      return imageFiles.isNotEmpty ? imageFiles : null;
    } catch (e) {
      print(e);
      final check = await handelPermission();
      if (check != true) return null;
      if (isMultiple) {
        images = await _picker.pickMultiImage();
      } else {
        images = [
          await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 100,
            maxWidth: 1080,
          )
        ];
      }
      List<File>? imageFiles =
          images.map<File>((xfile) => File(xfile?.path ?? "")).toList();
      return imageFiles.isNotEmpty ? imageFiles : null;
    }

    // final check = await handelPemission();
    // if (check != true) return null;
    // if (isMultiple) {
    //   images = await _picker.pickMultiImage();
    // } else {
    //   images = [
    //     await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxWidth:1080,maxHight:1920,)
    //   ];
    // }
    // List<File>? imageFiles =
    //     images.map<File>((xfile) => File(xfile?.path ?? "")).toList();
    // return imageFiles.isNotEmpty ? imageFiles : null;
  }

  final FilePicker _filePicker = FilePicker.platform;

  Future<List<File>?> pickFiles({int limit = 5}) async {
    FilePickerResult? result = await _filePicker.pickFiles(
        type: FileType.media,
        // allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
        allowMultiple: true,
        compressionQuality: 20000,
        allowCompression: true);
    if (result != null) {
      List<File>? imageFiles =
          result.files.map<File>((xfile) => File(xfile.path ?? "")).toList();
      if (imageFiles.length > limit) {
        Alerts.snack(
            text: "${'limit_image'.tr()} $limit", state: SnackState.failed);
        return <File>[];
      } else if (imageFiles.length > 1 && imageFiles.length > 50) {
        // remove file more than 50 mb
        imageFiles.removeWhere((element) => element.lengthSync() > 50000000);
        Alerts.snack(text: "max_size_50mb".tr(), state: SnackState.failed);
        return imageFiles;
      } else {
        List<File> compressedFiles = [];
        for (File image in imageFiles) {
          final tempDir = await getTemporaryDirectory();
          final targetPath =
              "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
          final compressedFile = (image.path.toLowerCase().endsWith('.mp4') ||
                  image.path.toLowerCase().endsWith('.mov'))
              ? image
              : await testCompressAndGetFile(image, targetPath);
          compressedFiles.add(compressedFile);
        }

        return compressedFiles;
      }

      // convert heic to png in case of ios
      // if (Platform.isIOS) {

      // remove file more than 50 mb
      // imageFiles.removeWhere((element) => element.lengthSync() > 50000000);
      // imageFiles.first.
      // Alerts.snack(text: "max_size_50mb".tr(), state: SnackState.failed);

      // return imageFiles;
    }
    return null;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 30,
    );

    return File(result?.path ?? "");
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1080,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      print(e);
      final check = await handelPermission();
      if (check != true) return null;
      final image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100, maxWidth: 1080);
      return image != null ? File(image.path) : null;
    }
  }

  Future<File?> pickImageFromCamera() async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100, maxWidth: 1080);
      return image != null ? File(image.path) : null;
    } catch (e) {
      print(e);
      final check = await handelCameraPermission();
      if (check != true) return null;
      final image = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: 100, maxWidth: 1080);
      return image != null ? File(image.path) : null;
    }
    // final check = await handelCameraPermission();
    // if (check != true) return null;
    // final image =
    //     await _picker.pickImage(source: ImageSource.camera, imageQuality: 100, maxWidth:1080,maxHight:1920,);
    // return image != null ? File(image.path) : null;
  }

  static handelPermission() async {
    late PermissionStatus status;
    late AndroidDeviceInfo androidInfo;
    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
    }

    if (Platform.isAndroid && androidInfo.version.sdkInt <= 32) {
      /// use [Permissions.storage.status]
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      await openSettingPermissionDialog();
    } else {
      return true;
    }
  }

  static handelCameraPermission() async {
    late PermissionStatus status;

    status = await Permission.camera.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      await openSettingPermissionDialog();
    } else {
      return true;
    }
  }

  static Future<dynamic> openSettingPermissionDialog() {
    return showDialog(
        context: Utils.navigatorKey().currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: CustomText('Permission'.tr()),
            content: CustomText(
                'Please enable camera permission from app settings'.tr()),
            actions: [
              TextButtonWidget(
                function: () => Navigator.of(context).pop(),
                text: 'Cancel'.tr(),
              ),
              TextButtonWidget(
                function: () => openAppSettings()
                    .then((value) => Navigator.of(context).pop()),
                text: 'Settings'.tr(),
              ),
            ],
          );
        });
  }
}
