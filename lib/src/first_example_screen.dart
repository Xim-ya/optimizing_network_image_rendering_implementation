import 'package:flutter/material.dart';
import 'package:optimizing_network_image_rendering_implementation/src/image_extension.dart';

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
            Image.network(
              imageUrl,
              width: 250,
              cacheWidth: 250.cacheSize(context),
            ),
            const Divider(),
            Image.network(
              imageUrl,
              width: 250,
            ),
          ],
        ),
      ),
    );
  }
}
