// lib/widgets/food_card_widget.dart

import 'package:flutter/material.dart';
import '../models/food_deliver_response_model.dart';

class FoodCard extends StatelessWidget {
  final FoodDeliveryRecipeModel recipe;
  final VoidCallback onTap;
  final bool isFavorite;
  final Function(int)? onToggleFavorite;

  const FoodCard({
    Key? key,
    required this.recipe,
    required this.onTap,
    this.isFavorite = false,
    this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 22, top: 70, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -60,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(
                    recipe.image,
                  ),
                  onBackgroundImageError: (exception, stacktrace) {
                    debugPrint('Error loading image for ${recipe.name}: $exception');
                  },
                ),
              ),
            ),
            // Favorite Button
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  if (onToggleFavorite != null) {
                    onToggleFavorite!(recipe.id);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 80.0,
              child: Padding(
                // *** Adjusted: Reduced bottom padding slightly ***
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0), // Reduced from 10.0 to 5.0
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          recipe.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // *** Adjusted: Reduced SizedBox height slightly ***
                    const SizedBox(height: 5), // Reduced from 8 to 5

                    Text(
                      '${recipe.cuisine}', // This could also be price from model, e.g., '₦${recipe.price}'
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    // *** Adjusted: Removed final SizedBox, or reduce it more if needed ***
                    // const SizedBox(height: 5), // Optional: If overflow still occurs, remove or make smaller
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}