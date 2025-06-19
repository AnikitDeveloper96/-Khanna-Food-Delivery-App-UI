import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/screens/login_signup.dart';

class AppRoutes {
  AppRoutes._();

  static const String loginSignup = '/loginSignup';

  static const String homeRoute = '/home';

  static Map<String, WidgetBuilder> get routes {
    return {
      loginSignup: (context) => LoginPage(),
    };
  }
}
