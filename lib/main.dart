import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nepal_digit/screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Homepage',
      home: Dashboard(),
    );
  }
}
