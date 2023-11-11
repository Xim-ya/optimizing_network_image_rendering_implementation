import 'package:efficient_image_caching_implementation/src/chached_image_extension.dart';
import 'package:flutter/material.dart';

class FirstExampleScreen extends StatelessWidget {
  const FirstExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const imageUrl =
        'https://www.themoviedb.org/t/p/original/rZy9EJaRmESKjEMz5XgG81jZloS.jpg';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text('Resized Image'),
                Image.network(
                  imageUrl,
                  width: 250,
                  cacheWidth: 250.cacheSize(context),
                ),
              ],
            ),
            const Divider(),
            Column(
              children: [
                const Text('Original Image'),
                Image.network(
                  imageUrl,
                  width: 250,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
