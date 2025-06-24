abstract class FoodDeliveryProductEvent {}

class FetchFoodDeliveryProducts extends FoodDeliveryProductEvent {}

class SelectCuisine extends FoodDeliveryProductEvent {
  final String cuisine;
  SelectCuisine(this.cuisine);
}