import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoo App',
      theme: ThemeData(
          primarySwatch: Colors.yellow,
          scaffoldBackgroundColor: const Color(0xf3c766)),
      home: Loading(),
    );
  }
}
