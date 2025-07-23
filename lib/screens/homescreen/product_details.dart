// lib/screens/homescreen/product_details.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc
import 'package:fooddeliveryapp/models/food_deliver_response_model.dart';
import 'package:fooddeliveryapp/screens/cartpage.dart';
// import 'package:fooddeliveryapp/screens/checkout_page.dart'; // Assuming this model exists if used

// Import your Bloc and Events
import '../../bloc/blocs/food_delivery_bloc.dart';
import '../../bloc/bloc_events/food_delivery_events.dart';
import '../../bloc/bloc_state/food_delivery_states.dart';

class KhannaProductDetailScreen extends StatefulWidget {
  final FoodDeliveryRecipeModel recipe;
  const KhannaProductDetailScreen({required this.recipe, super.key});

  @override
  State<KhannaProductDetailScreen> createState() =>
      _KhannaProductDetailScreenState();
}

class _KhannaProductDetailScreenState extends State<KhannaProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Wrap the Scaffold with BlocBuilder to react to state changes
    return BlocBuilder<FoodDeliveryBloc, FoodDeliveryProductState>(
      builder: (context, state) {
        bool isFavorite = false; // Default
        if (state is FoodDeliveryProductLoaded) {
          isFavorite = state.favoriteRecipeIds.contains(widget.recipe.id);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF8F8F8),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: SvgPicture.asset(
                "assets/images/chevron_left_png.svg", // Ensure this path is correct
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
                placeholderBuilder:
                    (BuildContext context) =>
                        const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () {
                    // Dispatch the ToggleFavoriteRecipe event
                    if (state is FoodDeliveryProductLoaded) {
                      context.read<FoodDeliveryBloc>().add(
                        ToggleFavoriteRecipe(widget.recipe.id),
                      );
                    }
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 28,
                    color:
                        isFavorite
                            ? Colors.red
                            : Colors
                                .black, // Change color based on favorite status
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 110,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.recipe.image),
                onBackgroundImageError: (exception, stacktrace) {
                  // Optional: Add a placeholder image or icon for error
                  debugPrint('Error loading image: $exception');
                },
              ),
              const SizedBox(height: 10),
              // Pagination dots (logic still seems to reference recipe.image.length)
              // Note: recipe.image is a String, so .length here refers to string length.
              // If you intended this for multiple images, you'd need a list of images in your model.
              // For a single image, this section might be removed or simplified.
              widget.recipe.image.isNotEmpty &&
                      widget.recipe.image.length >
                          0 // Check for a valid image string
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        width: 7.0,
                        height: 7.0,
                        decoration: BoxDecoration(
                          color:
                              Colors
                                  .deepOrange, // Always highlight for single image
                          shape: BoxShape.circle,
                        ),
                      ),
                      // If there were more images, you'd loop here for other dots
                      // e.g., if recipe.images was List<String>
                      // ... for (int i = 1; i < recipe.images.length; i++) { ... }
                    ],
                  )
                  : const SizedBox.shrink(), // No dots if no image or empty string
              const SizedBox(height: 16),
              Text(
                widget.recipe.name,
                textAlign:
                    TextAlign.center, // Added textAlign for better centering
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.recipe.caloriesPerServing * 10}', // Using calories as a placeholder for price, as per FoodCard
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Delivered between monday aug and thursday 20 from 8pm to 91:32 pm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Return policy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      ); // Added const
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'Add to cart',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
