import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/extensions/all_extensions.dart';

import '../../core/utils/extentions.dart';
import 'shimer_loading_items.dart';

class NetworkImagesWidgets extends StatelessWidget {
  const NetworkImagesWidgets(this.url,
      {super.key, this.fit, this.width, this.height, this.radius = 0});
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: url != ''
          ? CachedNetworkImage(
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  LoadingImage(w: width, h: double.infinity)
                      .paddingAll(0)
                      .center(),
              fit: fit,
              imageUrl: url,
              errorWidget: (context, _, __) =>
                  Image.asset("logo".png("icons"), fit: BoxFit.contain),
            ).cornerRadiusWithClipRRect(radius)
          : Image.asset("logo".png('icons'), fit: BoxFit.contain),
    );
  }
}

class NetworkImagesObject extends CachedNetworkImageProvider {
  const NetworkImagesObject(this.url, {this.fit, this.width, this.height})
      : super('');
  @override
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: /*  url != ''
          ?  */
            NetworkImagesWidgets(
          url,
          height: height,
          width: width,
          fit: fit,
        )

        // CachedNetworkImage(
        //     progressIndicatorBuilder: (context, url, downloadProgress) =>
        //         Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Center(
        //           child: LoadingImage(
        //         w: width,
        //         h: double.infinity,
        //       )
        //           // CircularProgressIndicator(value: downloadProgress.progress)
        //           ),
        //     ),
        //     fit: fit,
        //     imageUrl: url,
        //     errorWidget: (context, _, __) => SvgPicture.asset(
        //       "icon_colored".svg("icons"),
        //       fit: BoxFit.contain,
        //       // color: AppColors.primiry,
        //     ),
        //   )
        // : SvgPicture.asset(
        //     "icon_colored".svg(),
        //     fit: BoxFit.contain,
        //     //color: AppColors.primiry,
        //   ),
        );
  }
}
