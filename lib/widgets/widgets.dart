import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/constants/color.dart';
import 'package:fooddeliveryapp/constants/dimensions.dart';

class FoodDeliveryAppWidgets {
  customButton(
    BuildContext context,
    Color buttonColor,
    String buttonText,
    Color textColor,
    double textSize,
    FontWeight fontweight,
    bool marginFromLeftRight,
    VoidCallback? onPressed, 
  ) {
    return GestureDetector
    (
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 36,
          left: marginFromLeftRight?AppDimensions.marginLarge:0,
          right:marginFromLeftRight? AppDimensions.marginLarge:0,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            buttonText,
            style: TextStyle(color: textColor,
            fontSize: textSize,fontWeight: fontweight),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
  /// homescreen
  Widget foodCard(BuildContext context,String imageUrl,String name ,String receipePrice)
  {
    return 
    GestureDetector(
      // Allows the card to be tappable
      onTap: () {
        // For demonstration, let's just print a message
      },
      child: Container(
        // The main container for the card's background and styling
        width: 180, // Fixed width for the card
        margin: const EdgeInsets.only(
            right: 15), // Spacing between cards in a horizontal list
        decoration: BoxDecoration(
          color: Colors.white, // White background for the card
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            // Subtle shadow effect
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Light grey shadow
              spreadRadius: 2, // How far the shadow spreads
              blurRadius: 5, // How blurry the shadow is
              offset: const Offset(0, 3), // Shadow offset (x, y)
            ),
          ],
        ),
        child: Column(
          // Arranges the image, name, and price vertically
          mainAxisAlignment: MainAxisAlignment
              .center, // Centers content vertically within the card
          children: [
            Container(
              // Container for the circular image
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Makes the container circular
                color: Colors
                    .grey[200], // Background color for the circle (useful as a placeholder or loading)
                image: DecorationImage(
                  image: NetworkImage(imageUrl), // Loads image from a URL
                  fit: BoxFit.cover, // Ensures the image covers the circle
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between image and text
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Horizontal padding for the text
              child: Text(
                name,
                textAlign: TextAlign.center, // Centers the text if it wraps
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5), // Space between name and price
            Text(
              receipePrice,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.deepOrange, // Orange color for the price
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
