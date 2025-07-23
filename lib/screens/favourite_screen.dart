// lib/screens/favorite_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddeliveryapp/widgets/food_card_widget.dart';
import 'package:fooddeliveryapp/screens/homescreen/product_details.dart';

import '../bloc/bloc_events/food_delivery_events.dart';
import '../bloc/bloc_state/food_delivery_states.dart';
import '../bloc/blocs/food_delivery_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FoodDeliveryBloc, FoodDeliveryProductState>(
        builder: (context, state) {
          if (state is FoodDeliveryProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodDeliveryProductLoaded) {
            final favoriteRecipes = state.allRecipes
                .where((recipe) => state.favoriteRecipeIds.contains(recipe.id))
                .toList();

            if (favoriteRecipes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No favorites yet!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Tap the heart icon on a recipe to add it to your favorites.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85, // Adjust as needed
              ),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                final bool isFavorite = state.favoriteRecipeIds.contains(recipe.id);
                return FoodCard(
                  recipe: recipe,
                  isFavorite: isFavorite,
                  onToggleFavorite: (recipeId) {
                    BlocProvider.of<FoodDeliveryBloc>(context).add(ToggleFavoriteRecipe(recipeId));
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => KhannaProductDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is FoodDeliveryProductError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}