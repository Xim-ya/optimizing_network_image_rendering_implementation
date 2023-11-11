import 'package:efficient_image_caching_implementation/src/route_screen.dart';
import 'package:flutter/material.dart';

void main() {
  debugInvertOversizedImages = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const RouteScreen(),
    );
  }
}
