import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddeliveryapp/appRoutes.dart';
import 'package:fooddeliveryapp/bloc/blocs/food_delivery_bloc.dart';
import 'package:fooddeliveryapp/screens/homescreen/home_screen.dart';
import 'package:fooddeliveryapp/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(),

      child: MaterialApp(
      routes: AppRoutes.routes,
        title: 'Food Delivery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}