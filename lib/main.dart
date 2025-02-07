import 'package:flutter/material.dart';
import 'package:update_contact/Pages/home.dart';
import 'package:update_contact/Theme/theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Contact',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const homePage(),
    );
  }
}

