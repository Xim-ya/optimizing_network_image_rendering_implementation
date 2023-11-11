import 'package:cached_network_image/cached_network_image.dart';
import 'package:efficient_image_caching_implementation/src/chached_image_extension.dart';
import 'package:flutter/material.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugInvertOversizedImages = true;
    const imageUrl =
        'https://www.themoviedb.org/t/p/original/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 889 x 500

            // 889 x 500
            // Builder(
            //   builder: (context) {
            //     int? cacheWidth, cacheHeight;
            //     Size targetSize = const Size(250, 250);
            //     const double originImgAspectRatio = 1.7;
            //
            //     if (originImgAspectRatio > 0) {
            //       cacheHeight = targetSize.height.cacheSize(context);
            //     } else {
            //       cacheWidth = targetSize.width.cacheSize(context);
            //     }
            //
            //     return Image.network(
            //       imageUrl,
            //       width: targetSize.width,
            //       height: targetSize.height,
            //       cacheWidth: cacheWidth,
            //       cacheHeight: cacheHeight,
            //       fit: BoxFit.cover,
            //     );
            //   },
            // ),

            const Divider(),
            CachedNetworkImage(
              imageUrl: imageUrl,
              memCacheHeight: 320.cacheSize(context),
              memCacheWidth: 250.cacheSize(context),
            ),
          ],
        ),
      ),
    );
  }
}
