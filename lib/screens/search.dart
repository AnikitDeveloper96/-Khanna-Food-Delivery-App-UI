// lib/screens/search_results_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddeliveryapp/bloc/blocs/food_delivery_bloc.dart';
import 'package:fooddeliveryapp/widgets/food_card_widget.dart'; // Using your FoodCard
import 'package:fooddeliveryapp/screens/homescreen/product_details.dart';

import '../bloc/bloc_events/food_delivery_events.dart';
import '../bloc/bloc_state/food_delivery_states.dart'; // For navigation to details

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  const SearchResultsScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    // Immediately trigger a search if an initial query is provided
    if (widget.initialQuery.isNotEmpty) {
      BlocProvider.of<FoodDeliveryBloc>(context)
          .add(SearchFoodDeliveryProducts(widget.initialQuery));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Match home screen appBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true, // Focus on the search bar immediately
          decoration: InputDecoration(
            hintText: 'Search for food...',
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
                BlocProvider.of<FoodDeliveryBloc>(context)
                    .add(SearchFoodDeliveryProducts('')); // Clear search results
              },
            )
                : null,
          ),
          onChanged: (query) {
            BlocProvider.of<FoodDeliveryBloc>(context)
                .add(SearchFoodDeliveryProducts(query));
          },
          onSubmitted: (query) {
            // Optional: You can trigger a final search on submit if needed
            // For real-time search, onChanged is sufficient.
          },
        ),
      ),
      body: BlocBuilder<FoodDeliveryBloc, FoodDeliveryProductState>(
        builder: (context, state) {
          if (state is FoodDeliveryProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodDeliveryProductLoaded) {
            if (_searchController.text.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Start typing to search for recipes.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (state.searchResults.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off, // Icon for no results found
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Item not found',
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
                        'Try searching for food with a different keyword.',
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Found ${state.searchResults.length} results',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.62, // Adjusted to allow more vertical space
                    ),
                    itemCount: state.searchResults.length,
                    itemBuilder: (context, index) {
                      final recipe = state.searchResults[index];
                      final bool isFavorite = state.favoriteRecipeIds.contains(recipe.id);
                      return FoodCard(
                        recipe: recipe,
                        isFavorite: isFavorite,
                        isGridView: true,
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
                  ),
                ),
              ],
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