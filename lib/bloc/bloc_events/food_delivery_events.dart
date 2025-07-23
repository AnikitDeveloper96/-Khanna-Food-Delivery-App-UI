abstract class FoodDeliveryProductEvent {}

class FetchFoodDeliveryProducts extends FoodDeliveryProductEvent {}

class SelectCuisine extends FoodDeliveryProductEvent {
  final String cuisine;
  SelectCuisine(this.cuisine);
}

// Search and favouites as well inside khanna app
class SearchFoodDeliveryProducts extends FoodDeliveryProductEvent {
  final String query;
  SearchFoodDeliveryProducts(this.query);
}

class ToggleFavoriteRecipe extends FoodDeliveryProductEvent {
  final int recipeId;
  ToggleFavoriteRecipe(this.recipeId);
}