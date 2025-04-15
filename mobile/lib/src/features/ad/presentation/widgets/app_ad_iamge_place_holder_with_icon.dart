import 'package:eqshare_mobile/src/core/res/app_images.dart';
import 'package:flutter/material.dart';

class AppAdIamgePlaceHolderWithIcon extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit? imageBoxFit;
  const AppAdIamgePlaceHolderWithIcon({super.key, this.height, this.width, this.imageBoxFit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height??  MediaQuery.of(context).size.height * 0.16,
      width:width?? double.maxFinite,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          fit:imageBoxFit?? BoxFit.fitHeight,
          opacity: 0.5,
          image: AssetImage(
            AppImages.imagePlaceholderWithIcon,
          ),
        ),
      ),
    );
  }
}
