import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/screens/cartpage.dart';
import 'package:fooddeliveryapp/screens/checkout_page.dart';
import 'package:fooddeliveryapp/screens/favourite_screen.dart';
import 'package:fooddeliveryapp/screens/history.dart';
import 'package:fooddeliveryapp/screens/homescreen/home_screen.dart';
import 'package:fooddeliveryapp/screens/homescreen/list_of_cuisine.dart';
import 'package:fooddeliveryapp/screens/login_signup.dart';
import 'package:fooddeliveryapp/screens/myoffers.dart';
import 'package:fooddeliveryapp/screens/onboarding_screen.dart';
import 'package:fooddeliveryapp/screens/orders.dart';
import 'package:fooddeliveryapp/screens/payment_screen.dart';
import 'package:fooddeliveryapp/screens/profile.dart';
import 'package:fooddeliveryapp/screens/search.dart';

class AppRoutes {
  AppRoutes._();

  static const String loginSignup = '/loginSignup';

  static const String homeRoute = '/home';
  static const String listofCusine = '/listofCusine';
  static const String favourites = '/favourites';

  static const String cartPage = '/cartPage';
  static const String checkoutPage = '/checkoutPage';
  static const String history = '/history';
  static const String myOffers = '/myOffers';
  static const String onboardingScreen = '/onboardingScreen';
  static const String myorders = '/myOrders';
  static const String productDetailsScreen = '/productDetailsScreen';
  static const String myProfile = '/myProfile';
  static const String searchScreen = '/searchScreen';
  static const String paymentScreen = '/paymentScreen';

  static Map<String, WidgetBuilder> get routes {
    return {
      loginSignup: (context) => LoginPage(),
      homeRoute: (context) => HomeScreen(),
      listofCusine: (context) => AllCuisinesScreen(allRecipes: []),
      history: (context) => HistoryScreen(),
      onboardingScreen: (context) => OnboardingScreen(),
      myorders: (context) => OrderScreen(),
      myProfile: (context) => ProfileScreen(),
      myOffers: (context) => MyOffers(),
      favourites: (context) => FavoriteScreen(),
      searchScreen: (context) => SearchResultsScreen(initialQuery: ''),
      cartPage: (context) => CartScreen(),
      checkoutPage: (context) {
        final totalAmount =
            ModalRoute.of(context)?.settings.arguments as double? ?? 0.0;
        return CheckoutDeliveryScreen(
          totalAmount: totalAmount,
        ); // ✅ Using passed amount
      },
      paymentScreen: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>? ??
            {};
        final totalAmount = args['totalAmount'] as double? ?? 0.0;
        final deliveryMethod =
            args['deliveryMethod'] as String? ?? 'Door delivery';
        return PaymentScreen();
      },
    };
  }
}
