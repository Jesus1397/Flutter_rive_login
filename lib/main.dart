import 'package:flutter/material.dart';
import 'package:login/screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 12, 12, 12),
            body: LoginScreen(),
          ),
        ),
      ),
    );
  }
}
