// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinar_store/core/utils/app_colors.dart';
import 'package:dinar_store/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyCachedNetworkImage extends StatelessWidget {
  const MyCachedNetworkImage({
    super.key,
    this.height,
    this.width,
    required this.url,
    required this.errorIcon,
    required this.loadingWidth,
    this.fit,
  });

  final double? height;
  final double? width;
  final String url;
  final Icon errorIcon;
  final double loadingWidth;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      // imageUrl: "http://just.sd/dinar/public/storage/$url",
      imageUrl: "${appDomain.replaceAll("index.php/api", "storage")}$url",
// "https://dinnari.com/public/index.php/api/"
      fit: fit ?? BoxFit.cover,
      errorWidget: (context, url, error) {
        return errorIcon;
      },
      placeholder: (context, url) => SpinKitThreeBounce(
        color: AppColors.primaryColor,
        size: loadingWidth,
      ),
    );
  }
}
