import 'package:flutter/material.dart';
import 'package:optimizing_network_image_rendering_implementation/src/route_screen.dart';

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
      title: 'Optimizing Network Image Rendering Implementation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const RouteScreen(),
    );
  }
}
