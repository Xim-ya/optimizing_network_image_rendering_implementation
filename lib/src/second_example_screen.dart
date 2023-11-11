import 'package:flutter/material.dart';
import 'package:optimizing_network_image_rendering_implementation/src/image_extension.dart';

class SecondExampleScreen extends StatelessWidget {
  const SecondExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const imageUrl =
        'https://www.themoviedb.org/t/p/original/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text('Responsive Resized Image'),
                Builder(
                  builder: (context) {
                    int? cacheWidth, cacheHeight;
                    Size targetSize = const Size(250, 250);
                    const double originImgAspectRatio = 1.7;

                    if (originImgAspectRatio > 0) {
                      cacheHeight = targetSize.height.cacheSize(context);
                    } else {
                      cacheWidth = targetSize.width.cacheSize(context);
                    }

                    return Image.network(
                      imageUrl,
                      width: targetSize.width,
                      height: targetSize.height,
                      cacheWidth: cacheWidth,
                      cacheHeight: cacheHeight,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            Column(
              children: [
                const Text('Original Image'),
                Image.network(
                  imageUrl,
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
