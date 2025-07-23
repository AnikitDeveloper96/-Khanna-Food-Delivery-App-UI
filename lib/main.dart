// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddeliveryapp/appRoutes.dart';
import 'package:fooddeliveryapp/bloc/blocs/food_delivery_bloc.dart';
import 'package:fooddeliveryapp/screens/onboarding_screen.dart';

import 'bloc/bloc_events/food_delivery_events.dart'; // Your OnboardingScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Corrected Bloc name from RecipeBloc to FoodDeliveryBloc
      // And dispatch the initial fetch event here
      create: (context) => FoodDeliveryBloc()..add(FetchFoodDeliveryProducts()),
      child: MaterialApp(
        routes: AppRoutes.routes, // Using your defined AppRoutes
        title: 'Food Delivery App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange, // Consistent primary color
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: const Color(0xFFF9F9F9), // Consistent background color
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF9F9F9), // Consistent app bar background
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
          ),
        ),
        home: const OnboardingScreen(), // Your specified initial screen
      ),
    );
  }
}