import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // App Title: 22–28, w600–w700
  static TextStyle appTitle = GoogleFonts.poppins(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  // Section Head: 18–22, w500
  static TextStyle sectionHead = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  // Body Text: 14–16, w400
  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black87,
  );

  // Button Text: 14–16, w600
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // onboardingscreen
  static TextStyle onboardingText = GoogleFonts.poppins(
    fontSize: 55,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
