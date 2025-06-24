
import 'package:fooddeliveryapp/models/food_deliver_response_model.dart';

abstract class FoodDeliveryProductState {}

class FoodDeliveryProductInitial extends FoodDeliveryProductState {}

class FoodDeliveryProductLoading extends FoodDeliveryProductState {}

class FoodDeliveryProductLoaded extends FoodDeliveryProductState {
  final List<FoodDeliveryRecipeModel> allRecipes; // All fetched recipes
  final List<FoodDeliveryRecipeModel> filteredRecipes; // Recipes filtered by cuisine
  final String selectedCuisine; // Currently selected cuisine tab

  FoodDeliveryProductLoaded(this.allRecipes, this.filteredRecipes, this.selectedCuisine);
}

class FoodDeliveryProductError extends FoodDeliveryProductState {
  final String message;
  FoodDeliveryProductError(this.message);
}