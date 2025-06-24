// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart'; // Import for listEquals

import '../../bloc/bloc_events/food_delivery_events.dart';
import '../../bloc/bloc_state/food_delivery_states.dart';
import '../../bloc/blocs/food_delivery_bloc.dart';
import '../../models/food_deliver_response_model.dart'; // Ensure FoodDeliveryRecipeModel has a 'price' field
import 'list_of_cuisine.dart'; // Import the new screen (assuming this is your AllCuisinesScreen equivalent)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0; // For Bottom Navigation Bar
  TabController? _tabController;
  List<String> _cuisineTabs = []; // Will be dynamically populated (max 4)
  List<FoodDeliveryRecipeModel> _allRecipesFromBloc = []; // To hold ALL recipes for 'See More' screen

  @override
  void initState() {
    super.initState();
    // Initialize _tabController with a minimal length (e.g., 1 for "All") initially.
    // It will be re-initialized in the listener once the actual cuisine data is loaded.
    _tabController = TabController(length: 1, vsync: this);
    _cuisineTabs = ['All']; // Ensure initial _cuisineTabs matches initial controller length

    // Dispatch the event to fetch products when the screen initializes
    context.read<RecipeBloc>().add(FetchFoodDeliveryProducts());
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // UPDATED: _buildFoodCard now takes a FoodDeliveryRecipeModel object
  Widget _buildFoodCard(
      BuildContext context,
      FoodDeliveryRecipeModel recipe, // Takes the entire recipe object
      ) {
    return GestureDetector(
      onTap: () {
        print('Tapped on ${recipe.name}');
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                image: DecorationImage(
                  image: NetworkImage(recipe.image), // Use recipe.image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                recipe.name, // Use recipe.name
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              // Displaying food price. Assuming 'price' is a double or int.
              // Using toStringAsFixed(2) for a common currency format.
              '\$${recipe.caloriesPerServing.toStringAsFixed(2)}', // <-- Changed to price
              style: const TextStyle(
                fontSize: 16,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Handle menu button press
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              // Handle cart button press
            },
          ),
        ],
      ),
      body: BlocConsumer<RecipeBloc, FoodDeliveryProductState>(
        listener: (context, state) {
          if (state is FoodDeliveryProductLoaded) {
            _allRecipesFromBloc = state.allRecipes; // Store all recipes

            // Get all unique cuisines from the API for potential tabs and 'See More' screen
            final allUniqueCuisines = state.allRecipes.map((e) => e.cuisine).toSet().toList();
            allUniqueCuisines.sort(); // Sort for consistent tab order

            List<String> newCuisineTabs = ['All']; // Always start with 'All' tab

            // Filter out 'All' and take up to 3 more distinct cuisine names for the main tabs
            final dynamicCuisines = allUniqueCuisines
                .where((c) => c.toLowerCase() != 'all')
                .take(3) // Take up to 3 dynamic cuisines to have total 4 tabs (All + 3 Cuisines)
                .toList();

            newCuisineTabs.addAll(dynamicCuisines);

            // Only recreate TabController if the list of tabs has genuinely changed
            if (!listEquals(_cuisineTabs, newCuisineTabs)) {
              setState(() {
                _cuisineTabs = newCuisineTabs;
                // Dispose the old controller to prevent ticker errors when length changes
                _tabController?.dispose();
                // Create a new TabController with the correct, updated length
                _tabController = TabController(length: _cuisineTabs.length, vsync: this);

                // Re-add the listener for the newly created TabController
                _tabController!.addListener(() {
                  if (!_tabController!.indexIsChanging) {
                    final selectedTabCuisine = _cuisineTabs[_tabController!.index];
                    context.read<RecipeBloc>().add(SelectCuisine(selectedTabCuisine));
                  }
                });

                // Set the initial index based on the Bloc's current selected cuisine
                final newIndex = _cuisineTabs.indexOf(state.selectedCuisine);
                if (newIndex != -1) { // Only set if the cuisine is found in the new list
                  _tabController!.index = newIndex;
                } else if (_cuisineTabs.isNotEmpty) {
                  // If selected cuisine is not in the limited tabs (e.g., it was a cuisine from 'See More' list)
                  // default to 'All' tab to ensure a valid tab is selected.
                  _tabController!.index = 0; // Default to 'All' tab
                  context.read<RecipeBloc>().add(SelectCuisine('All'));
                }
              });
            } else {
              // If tabs themselves haven't changed, but the selected cuisine in the Bloc state might have,
              // ensure the TabController's index is updated to match.
              final newIndex = _cuisineTabs.indexOf(state.selectedCuisine);
              if (newIndex != -1 && _tabController != null && _tabController!.index != newIndex) {
                _tabController!.animateTo(newIndex);
              }
            }
          }
        },
        builder: (context, state) {
          return Column( // Use Column to stack different sections
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top fixed section (Delicious food, search bar) with horizontal padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delicious',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      'food for you',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // --- TabBar and "See More" in a Row, spans full width, with internal padding ---
              Row( // This Row now sits outside the main horizontal padding for the desired "left end" effect
                children: [
                  Expanded(
                    child: Padding( // Apply horizontal padding specific to the TabBar content
                      padding: const EdgeInsets.only(left: 0.0), // Changed to 0.0 for starting from left end
                      child: (
                          _tabController != null && _cuisineTabs.isNotEmpty && _tabController!.length == _cuisineTabs.length
                      )
                          ? TabBar(
                        controller: _tabController,
                        isScrollable: true, // Keep scrollable for varying tab counts
                        labelColor: Colors.deepOrange,
                        unselectedLabelColor: Colors.grey,
                        // Custom modern indicator styling with transparent color to remove underline
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // Rounded corners for indicator
                          color: Colors.deepOrange.withOpacity(0.0), // Set color to transparent to remove underline
                        ),
                        // Modern label styling
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab, // Indicator covers the whole tab area
                        // Add internal padding to the tabs to create space around text within the indicator
                        labelPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Added vertical padding
                        tabs: _cuisineTabs.map((cuisine) => Tab(text: cuisine)).toList(),
                      )
                          : _buildTabShimmerLoading(), // Show shimmer if tabs are not ready
                    ),
                  ),
                  // "See More" button for navigating to AllCuisinesScreen
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0), // Padding on the right to align with other content
                    child: TextButton(
                      onPressed: () {
                        // Ensure _allRecipesFromBloc is populated before navigating
                        if (state is FoodDeliveryProductLoaded) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AllCuisinesScreen( // Changed to ListOfCuisine based on your import
                                allRecipes: _allRecipesFromBloc, // Pass the full list of recipes
                              ),
                            ),
                          );
                        } else {
                          // Optionally show a message if recipes are not loaded yet
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Recipes are still loading...')),
                          );
                        }
                      },
                      child: const Text(
                        'See More',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Space after Row

              // Remaining scrollable content (Food List) with horizontal padding
              Expanded( // Expanded to allow the SingleChildScrollView to take available space
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0), // Apply padding here for the list content
                  child: Column(
                    children: [
                      SizedBox(
                        height: 250, // Fixed height for the horizontal food list
                        child: _buildRecipeList(state), // This list is horizontally scrollable
                      ),
                      const SizedBox(height: 20),
                      // ... potentially other content that needs to scroll below the food list
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 28),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 28),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 28),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  // Helper method to build the list of recipes based on the state
  Widget _buildRecipeList(FoodDeliveryProductState state) {
    if (state is FoodDeliveryProductLoading) {
      return _buildProductsShimmerLoading();
    } else if (state is FoodDeliveryProductLoaded) {
      if (state.filteredRecipes.isEmpty) {
        String message = 'No recipes found for this cuisine.';
        if (_cuisineTabs.isEmpty) {
          message = 'No cuisines available to display.';
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(message, textAlign: TextAlign.center),
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        itemCount: state.filteredRecipes.length,
        itemBuilder: (context, index) {
          final recipe = state.filteredRecipes[index];
          // UPDATED: Pass the entire recipe object to _buildFoodCard
          return _buildFoodCard(
            context,
            recipe,
          );
        },
      );
    } else if (state is FoodDeliveryProductError) {
      return Center(child: Text(state.message));
    }
    return const SizedBox.shrink(); // Default empty widget
  }

  // Shimmer effect for the horizontal product list while loading
  Widget _buildProductsShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Show a few shimmer cards horizontally
        itemBuilder: (context, index) {
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 10),
                SizedBox(width: 100, height: 16, child: ColoredBox(color: Colors.white)),
                SizedBox(height: 5),
                SizedBox(width: 60, height: 16, child: ColoredBox(color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }

  // Shimmer effect for the tabs while loading
  Widget _buildTabShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 40, // Approximate height of your TabBar
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4, // Show 4 shimmer placeholders for tabs
          itemBuilder: (context, index) {
            return Container(
              width: 80, // Approximate width of each shimmer tab
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper function to compare two lists (useful when deciding if setState is needed for _cuisineTabs)
  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

}