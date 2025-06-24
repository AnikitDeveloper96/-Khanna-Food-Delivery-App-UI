// lib/screens/all_cuisines_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddeliveryapp/models/food_deliver_response_model.dart';

import '../../bloc/bloc_events/food_delivery_events.dart';
import '../../bloc/blocs/food_delivery_bloc.dart';

class AllCuisinesScreen extends StatelessWidget {
  final List<FoodDeliveryRecipeModel> allRecipes; // Now accepts a list of Recipe objects

  const AllCuisinesScreen({Key? key, required this.allRecipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (allRecipes.isEmpty) {
      // This state should ideally not be reached if HomeScreen passes populated data,
      // but good for robustness.
      return Scaffold(
        appBar: AppBar(
          title: const Text('All Cuisines'),
        ),
        body: const Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    // Process recipes to get unique cuisines and a representative image for each
    final Map<String, String> cuisineImages = {};
    final List<String> uniqueCuisines = [];

    // Populate uniqueCuisines and cuisineImages map
    for (var recipe in allRecipes) {
      final cuisineName = recipe.cuisine;
      // Exclude 'All' if it somehow appears as a cuisine in the data
      if (!uniqueCuisines.contains(cuisineName) && cuisineName.toLowerCase() != 'all') {
        uniqueCuisines.add(cuisineName);
        // Take the first image encountered for this cuisine as its representative image
        if (!cuisineImages.containsKey(cuisineName)) {
          cuisineImages[cuisineName] = recipe.image;
        }
      }
    }
    uniqueCuisines.sort(); // Sort cuisines alphabetically for consistent display

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Cuisines'),
        backgroundColor: Colors.deepOrange, // Example app bar color
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 16.0, // Spacing between columns
          mainAxisSpacing: 16.0, // Spacing between rows
          childAspectRatio: 0.8, // Adjust aspect ratio for image and text
        ),
        itemCount: uniqueCuisines.length, // No "See More" item here
        itemBuilder: (context, index) {
          final cuisine = uniqueCuisines[index];
          // Use the stored image or a fallback if not found
          final imageUrl = cuisineImages[cuisine] ?? 'https://via.placeholder.com/150/CCCCCC/FFFFFF?text=No+Image';

          return GestureDetector(
            onTap: () {
              // Dispatch event to select this cuisine and navigate back to HomeScreen
              BlocProvider.of<RecipeBloc>(context).add(SelectCuisine(cuisine));
              Navigator.of(context).pop(); // Go back to HomeScreen
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias, // Clip children to card shape
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      // Error builder for broken image links
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      // Loading builder for image loading progress
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cuisine,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}