import 'package:flutter/material.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String imgUrl =
        'https://www.themoviedb.org/t/p/original/py7gDxOlcVxVPuw56thayohGFb0.jpg';
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Proper Cache
              Builder(
                builder: (context) {
                  Size targetCacheSize;
                  const targetSize = Size(250, 250);
                },
              ),

              const Divider(
                height: 1,
              ),
              Image.asset(
                '',
                cacheWidth: 200,
              ),
              Image.network(
                '${imgUrl}?${DateTime.now().millisecondsSinceEpoch.toString()}',
                fit: BoxFit.cover,
              ),

              Image.network(
                imgUrl,
                width: 250,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
