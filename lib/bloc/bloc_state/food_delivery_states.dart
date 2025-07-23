// lib/bloc_state/food_delivery_states.dart

import 'package:fooddeliveryapp/models/food_deliver_response_model.dart';

abstract class FoodDeliveryProductState {}

class FoodDeliveryProductInitial extends FoodDeliveryProductState {}

class FoodDeliveryProductLoading extends FoodDeliveryProductState {}

class FoodDeliveryProductLoaded extends FoodDeliveryProductState {
  final List<FoodDeliveryRecipeModel> allRecipes; // All fetched recipes
  final List<FoodDeliveryRecipeModel> filteredRecipes; // Recipes filtered by cuisine
  final String selectedCuisine; // Currently selected cuisine tab
  final List<FoodDeliveryRecipeModel> searchResults; // Results from the search query
  final Set<int> favoriteRecipeIds; // Set of favorite recipe IDs

  FoodDeliveryProductLoaded(
      this.allRecipes,
      this.filteredRecipes,
      this.selectedCuisine,
      this.searchResults,
      this.favoriteRecipeIds,
      );

  // Helper method to create a new state with updated values
  FoodDeliveryProductLoaded copyWith({
    List<FoodDeliveryRecipeModel>? allRecipes,
    List<FoodDeliveryRecipeModel>? filteredRecipes,
    String? selectedCuisine,
    List<FoodDeliveryRecipeModel>? searchResults,
    Set<int>? favoriteRecipeIds,
  }) {
    return FoodDeliveryProductLoaded(
      allRecipes ?? this.allRecipes,
      filteredRecipes ?? this.filteredRecipes,
      selectedCuisine ?? this.selectedCuisine,
      searchResults ?? this.searchResults,
      favoriteRecipeIds ?? this.favoriteRecipeIds,
    );
  }
}

class FoodDeliveryProductError extends FoodDeliveryProductState {
  final String message;
  FoodDeliveryProductError(this.message);
}