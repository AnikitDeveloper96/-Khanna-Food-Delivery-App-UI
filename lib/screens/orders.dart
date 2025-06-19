import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Correct import for SvgPicture
import 'package:fooddeliveryapp/constants/color.dart';
import 'package:fooddeliveryapp/widgets/widget_button.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ensure the AppBar is visible and styled as needed
        backgroundColor: Colors.transparent, // Example: make it transparent
        elevation: 0, // Remove shadow
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/chevron_left_png.svg", // Make sure this is an SVG file and path is correct
            width: 24, // Adjust size as needed
            height: 24, // Adjust size as needed
            colorFilter: ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ), // Apply color if SVG is monochrome
            placeholderBuilder:
                (BuildContext context) =>
                    const Icon(Icons.arrow_back), // Fallback for loading/error
          ),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text(
          "Orders",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          // textAlign is not needed here, AppBar title handles alignment
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ), // Add horizontal padding to the body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center items horizontally
          children: [
            // Top Spacer: Pushes content down from the top
            const Spacer(),

            // Group the Image and Text together for centering
            Column(
              mainAxisSize:
                  MainAxisSize
                      .min, // Take minimum vertical space for its children
              children: [
                Image.asset(
                  "assets/images/no_order_png.png",
                  // You might want to add width/height constraints or fit property here
                  // For example: height: 150, fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback: Display a placeholder if the image fails to load
                    return Container(
                      height: 150, // Example size for fallback
                      width: 150, // Example size for fallback
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.history,
                        size: 70,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20), // Spacing between image and text
                Text(
                  "No Orders yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                        Colors.grey[500], // Using a lighter grey for the text
                  ),
                  textAlign:
                      TextAlign.center, // Center text within its own space
                ),
              ],
            ),

            // Middle Spacer: Pushes the button to the bottom, balances top spacer
            const Spacer(),

            // "Start Ordering" button at the bottom
            FoodDeliveryAppWidgets().customButton(
              context,
              AppColors.primary, // Make sure AppColors.primary is defined
              "Start Ordering",
              Colors.white,
              17,
              FontWeight.bold,
              true, // This argument now matches the assumed signature in widget_button.dart
              () {
                Navigator.pop(
                  context,
                ); // Navigate back to the home screen or previous screen
              },
            ),
            const SizedBox(height: 20), // Add some padding below the button
          ],
        ),
      ),
    );
  }
}
