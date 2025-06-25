import 'package:flutter/material.dart';
import '../models/food_deliver_response_model.dart'; // Adjust path as per your project structure

class FoodCard extends StatelessWidget {
  final FoodDeliveryRecipeModel recipe;
  final VoidCallback? onTap; // Optional tap handler

  const FoodCard({
    Key? key,
    required this.recipe,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180, // Fixed width for each card as per design
        margin: const EdgeInsets.only(right: 15), // Margin between cards
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // Softer shadow
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            // Circular Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Using a background color as a subtle placeholder before image loads
                color: Colors.grey[200],
                image: DecorationImage(
                  image: NetworkImage(recipe.image),
                  fit: BoxFit.fill, // Cover the circle
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between image and name
            // Food Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                recipe.name,
                textAlign: TextAlign.center,
                maxLines: 2, // Allow up to 2 lines for long names
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Explicitly set text color
                ),
              ),
            ),
            const SizedBox(height: 5), // Space between name and price
            // Food Price
            Text(
              // Assuming caloriesPerServing is used as price
              'N${recipe.caloriesPerServing.toStringAsFixed(2)}', // Nigerian Naira currency symbol
              style: const TextStyle(
                fontSize: 16,
                color: Colors.deepOrange, // Prominent color for price
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}