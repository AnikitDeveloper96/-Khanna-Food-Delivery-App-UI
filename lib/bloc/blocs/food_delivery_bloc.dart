// lib/bloc/blocs/food_delivery_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:fooddeliveryapp/models/food_deliver_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../bloc_events/food_delivery_events.dart'; // Ensure this path is correct
import '../bloc_state/food_delivery_states.dart'; // Ensure this path is correct

class RecipeBloc
    extends Bloc<FoodDeliveryProductEvent, FoodDeliveryProductState> {
  List<FoodDeliveryRecipeModel> _allRecipes = []; // Holds all fetched recipes

  RecipeBloc() : super(FoodDeliveryProductInitial()) {
    on<FetchFoodDeliveryProducts>(_onFetchRecipes);
    on<SelectCuisine>(_onSelectCuisine);
  }

  Future<void> _onFetchRecipes(
    FetchFoodDeliveryProducts event,
    Emitter<FoodDeliveryProductState> emit,
  ) async {
    emit(FoodDeliveryProductLoading());
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/recipes'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> recipesJson = data['recipes'];
        _allRecipes =
            recipesJson
                .map((json) => FoodDeliveryRecipeModel.fromJson(json))
                .toList();

        // Determine initial selected cuisine for the first tab if available
        final uniqueCuisines =
            _allRecipes.map((e) => e.cuisine).toSet().toList();
        uniqueCuisines.sort(); // Sort for consistent tab order

        // Exclude 'All' (case-insensitive) if it somehow appears in raw data
        final filteredCuisines =
            uniqueCuisines.where((c) => c.toLowerCase() != 'all').toList();

        // Set the initial selected cuisine to 'All' to show all recipes initially
        String initialSelectedCuisine = 'All';

        List<FoodDeliveryRecipeModel> initialFilteredRecipes =
            _allRecipes; // Show all recipes for 'All' tab

        emit(
          FoodDeliveryProductLoaded(
            _allRecipes,
            initialFilteredRecipes,
            initialSelectedCuisine,
          ),
        );
      } else {
        // Handle API errors (e.g., 404, 500)
        emit(
          FoodDeliveryProductError(
            'Failed to load recipes: Server responded with status ${response.statusCode}',
          ),
        );
      }
    } on http.ClientException catch (e) {
      // Handle network errors (e.g., no internet connection)
      emit(
        FoodDeliveryProductError(
          'Network Error: Could not connect to the server. ${e.message}',
        ),
      );
    } on FormatException catch (e) {
      // Handle JSON parsing errors
      emit(
        FoodDeliveryProductError(
          'Data Error: Failed to parse recipe data. ${e.message}',
        ),
      );
    } catch (e) {
      // Catch any other unexpected errors
      emit(FoodDeliveryProductError('An unexpected error occurred: $e'));
    }
  }

  void _onSelectCuisine(
    SelectCuisine event,
    Emitter<FoodDeliveryProductState> emit,
  ) {
    if (state is FoodDeliveryProductLoaded) {
      final currentState = state as FoodDeliveryProductLoaded;
      List<FoodDeliveryRecipeModel> newFilteredRecipes;

      if (event.cuisine.toLowerCase() == 'all') {
        newFilteredRecipes = _allRecipes;
      } else {
        // Filter based on the exact cuisine name received from the tab
        newFilteredRecipes =
            _allRecipes
                .where(
                  (recipe) =>
                      recipe.cuisine.toLowerCase() ==
                      event.cuisine.toLowerCase(),
                )
                .toList();
      }

      emit(
        FoodDeliveryProductLoaded(
          currentState.allRecipes,
          newFilteredRecipes,
          event.cuisine,
        ),
      );
    }
  }
}
