import 'package:efficient_image_caching_implementation/src/first_example_screen.dart';
import 'package:efficient_image_caching_implementation/src/second_example_screen.dart';
import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstExampleScreen(),
                  ),
                );
              },
              child: const Text('First Example'),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecondExampleScreen(),
                  ),
                );
              },
              child: const Text('Second Example'),
            ),
          ],
        ),
      ),
    );
  }
}
