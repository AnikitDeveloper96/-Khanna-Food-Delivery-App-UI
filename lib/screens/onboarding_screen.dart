import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/appRoutes.dart';
import 'package:fooddeliveryapp/constants/color.dart';
import 'package:fooddeliveryapp/constants/dimensions.dart';
import 'package:fooddeliveryapp/constants/styles.dart';
import 'package:fooddeliveryapp/widgets/widget_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Widget onboardingBody() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align everything to the left generally
      children: [
        // 1. Container for Text and other elements that need the margin
        Container(
          margin: EdgeInsets.fromLTRB(
            AppDimensions.marginLarge, // Respects left margin
            AppDimensions.marginSmall,
            AppDimensions.marginLarge,
            0,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start, // Ensure text is left-aligned within its own container
            children: [
              Text(
                "Food for everyone ",
                style: AppTextStyles.onboardingText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 26),
              // Other widgets that need the margin...
            ],
          ),
        ),
        Image.asset("assets/images/onboarding_screen_png.png"),
        SizedBox(height: 16),
        FoodDeliveryAppWidgets().customButton(
          context,
          Colors.white,
          "Get Started",
          AppColors.primary,
          17,
          FontWeight.bold,
          () {
            // Navigate to the login screen using the named route
            Navigator.pushNamed(context, AppRoutes.loginSignup);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: onboardingBody(),
      ),
    );
  }
}
