import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/appRoutes.dart';
import 'package:fooddeliveryapp/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      home: OnboardingScreen(),
    );
  }
}
