// lib/bloc/recipe_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:fooddeliveryapp/models/food_deliver_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../bloc_events/food_delivery_events.dart';
import '../bloc_state/food_delivery_states.dart';

class FoodDeliveryBloc
    extends Bloc<FoodDeliveryProductEvent, FoodDeliveryProductState> {
  List<FoodDeliveryRecipeModel> _allRecipes = [];
  Set<int> _favoriteRecipeIds = {}; // Store favorite recipe IDs

  FoodDeliveryBloc() : super(FoodDeliveryProductInitial()) {
    on<FetchFoodDeliveryProducts>(_onFetchRecipes);
    on<SelectCuisine>(_onSelectCuisine);
    on<SearchFoodDeliveryProducts>(_onSearchProducts);
    on<ToggleFavoriteRecipe>(_onToggleFavorite);
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

        _allRecipes.sort((a, b) => a.cuisine.compareTo(b.cuisine));

        String initialSelectedCuisine = 'All';
        List<FoodDeliveryRecipeModel> initialFilteredRecipes = _allRecipes;

        emit(
          FoodDeliveryProductLoaded(
            _allRecipes,
            initialFilteredRecipes,
            initialSelectedCuisine,
            [], // Initial empty search results
            _favoriteRecipeIds, // Pass the current favorite IDs
          ),
        );
      } else {
        emit(
          FoodDeliveryProductError(
            'Failed to load recipes: Server responded with status ${response.statusCode}. Please try again later.',
          ),
        );
      }
    } on SocketException {
      emit(
        FoodDeliveryProductError(
          "Network Error: Could not connect to the server. Please check your internet connection and try again.",
        ),
      );
    } on http.ClientException catch (e) {
      String errorMessage =
          'Network connection issue. Please check your internet.';
      if (e.message.contains('Failed host lookup') ||
          e.message.contains('Connection refused')) {
        errorMessage =
        "Network Error: Could not reach 'dummyjson.com'. Please check your internet or try again later.";
      } else {
        errorMessage = 'A network error occurred: ${e.message}';
      }
      emit(FoodDeliveryProductError(errorMessage));
    } on FormatException catch (e) {
      emit(
        FoodDeliveryProductError(
          'Data Error: Failed to parse recipe data. The received data might be corrupted or in an unexpected format. ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        FoodDeliveryProductError(
          'An unexpected error occurred: $e. Please contact support.',
        ),
      );
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
        currentState.copyWith(
          filteredRecipes: newFilteredRecipes,
          selectedCuisine: event.cuisine,
        ),
      );
    }
  }

  void _onSearchProducts(
      SearchFoodDeliveryProducts event,
      Emitter<FoodDeliveryProductState> emit,
      ) {
    if (state is FoodDeliveryProductLoaded) {
      final currentState = state as FoodDeliveryProductLoaded;
      List<FoodDeliveryRecipeModel> newSearchResults = [];

      if (event.query.isEmpty) {
        newSearchResults = []; // Clear search results if query is empty
      } else {
        newSearchResults = _allRecipes
            .where((recipe) =>
        recipe.name.toLowerCase().contains(event.query.toLowerCase()) ||
            recipe.cuisine.toLowerCase().contains(event.query.toLowerCase()) ||
            recipe.ingredients.any((ingredient) =>
                ingredient.toLowerCase().contains(event.query.toLowerCase())))
            .toList();
      }

      emit(
        currentState.copyWith(
          searchResults: newSearchResults,
        ),
      );
    } else {
      // If the state is not loaded, we should ideally load products first.
      // For simplicity, we'll just emit an empty search result or error.
      emit(
        FoodDeliveryProductLoaded(
          _allRecipes,
          [], // No filtered recipes for search
          'All',
          [], // Empty search results initially
          _favoriteRecipeIds,
        ).copyWith(
          searchResults: [], // Default to empty if no products loaded
        ),
      );
    }
  }

  void _onToggleFavorite(
      ToggleFavoriteRecipe event,
      Emitter<FoodDeliveryProductState> emit,
      ) {
    if (state is FoodDeliveryProductLoaded) {
      final currentState = state as FoodDeliveryProductLoaded;
      if (_favoriteRecipeIds.contains(event.recipeId)) {
        _favoriteRecipeIds.remove(event.recipeId);
      } else {
        _favoriteRecipeIds.add(event.recipeId);
      }
      emit(
        currentState.copyWith(
          favoriteRecipeIds: Set<int>.from(_favoriteRecipeIds), // Create a new set to trigger rebuild
        ),
      );
    }
  }
}