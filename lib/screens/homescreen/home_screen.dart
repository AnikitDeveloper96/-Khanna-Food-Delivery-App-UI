// lib/screens/homescreen/home_screen.dart (Adjust path if different)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooddeliveryapp/appRoutes.dart'; // Ensure this exists and has your routes
import 'package:fooddeliveryapp/screens/homescreen/product_details.dart';
import 'package:fooddeliveryapp/widgets/drawer_header.dart'; // Assuming CustomNavigationDrawer is here
import 'package:fooddeliveryapp/widgets/food_card_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../../bloc/bloc_events/food_delivery_events.dart';
import '../../bloc/bloc_state/food_delivery_states.dart';
import '../../bloc/blocs/food_delivery_bloc.dart'; // Corrected Bloc name
import '../../models/food_deliver_response_model.dart';
import '../favourite_screen.dart';
import '../search.dart';
import 'list_of_cuisine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  TabController? _tabController;
  List<String> _cuisineTabs = [];
  List<FoodDeliveryRecipeModel> _allRecipesFromBloc = [];

  final AdvancedDrawerController _advancedDrawerController =
  AdvancedDrawerController();
  final TextEditingController _searchController =
  TextEditingController(); // Add controller for search bar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _cuisineTabs = ['All'];
    context.read<FoodDeliveryBloc>().add(FetchFoodDeliveryProducts());

    // Listen to changes in the search controller to clear text
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // This is optional: if you want to clear search results when text is cleared
    // and potentially update the UI for the search bar on HomeScreen
    if (_searchController.text.isEmpty) {
      // You could dispatch an event here to clear search results in Bloc
      // if you navigate back to HomeScreen and want the previous search state cleared.
      // For now, we rely on SearchResultsScreen to manage its own search state.
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _advancedDrawerController.dispose();
    _searchController.dispose(); // Dispose the search controller
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for BottomNavigationBar
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AppRoutes.homeRoute);
        break;
      case 1:

        Navigator.pushNamed(context, AppRoutes.favourites);
        break;
      case 2:

        Navigator.pushNamed(context, AppRoutes.myProfile);
        break;
      case 3:

        Navigator.pushNamed(context, AppRoutes.history);
        break;
    }
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAdvancedDrawer( // Assuming CustomAdvancedDrawer is your wrapper
      controller: _advancedDrawerController,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "Khanna",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: _handleMenuButtonPressed,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                // Handle cart button press
              },
            ),
          ],
        ),
        body: BlocConsumer<FoodDeliveryBloc, FoodDeliveryProductState>(
          listener: (context, state) {
            if (state is FoodDeliveryProductLoaded) {
              _allRecipesFromBloc = state.allRecipes;

              final allUniqueCuisines =
              state.allRecipes.map((e) => e.cuisine).toSet().toList();
              allUniqueCuisines.sort();

              List<String> newCuisineTabs = ['All'];
              final dynamicCuisines = allUniqueCuisines
                  .where((c) => c.toLowerCase() != 'all')
                  .take(3)
                  .toList();
              newCuisineTabs.addAll(dynamicCuisines);

              if (!listEquals(_cuisineTabs, newCuisineTabs)) {
                setState(() {
                  _cuisineTabs = newCuisineTabs;
                  _tabController?.dispose();
                  _tabController = TabController(
                    length: _cuisineTabs.length,
                    vsync: this,
                  );

                  _tabController!.addListener(() {
                    if (!_tabController!.indexIsChanging) {
                      final selectedTabCuisine =
                      _cuisineTabs[_tabController!.index];
                      context
                          .read<FoodDeliveryBloc>()
                          .add(SelectCuisine(selectedTabCuisine));
                    }
                  });

                  final newIndex = _cuisineTabs.indexOf(state.selectedCuisine);
                  if (newIndex != -1) {
                    _tabController!.index = newIndex;
                  } else if (_cuisineTabs.isNotEmpty) {
                    _tabController!.index = 0;
                    context.read<FoodDeliveryBloc>().add(SelectCuisine('All'));
                  }
                });
              } else {
                final newIndex = _cuisineTabs.indexOf(state.selectedCuisine);
                if (newIndex != -1 &&
                    _tabController != null &&
                    _tabController!.index != newIndex) {
                  _tabController!.animateTo(newIndex);
                }
              }
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      // Search Bar - Navigate to SearchResultsScreen
                      GestureDetector(
                        onTap: () {
                          // Clear the text field on home screen when navigating
                          _searchController.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsScreen(
                                initialQuery: _searchController.text, // Pass initial text if any
                              ),
                            ),
                          );
                        },
                        child: AbsorbPointer(
                          // Prevent direct typing in this text field
                          child: TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: (_tabController != null &&
                            _cuisineTabs.isNotEmpty &&
                            _tabController!.length == _cuisineTabs.length)
                            ? TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: Colors.deepOrange,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.deepOrange,
                          indicatorWeight: 3.0,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          tabs: _cuisineTabs
                              .map((cuisine) => Tab(text: cuisine))
                              .toList(),
                        )
                            : _buildTabShimmerLoading(),
                      ),
                      TextButton(
                        onPressed: () {
                          if (state is FoodDeliveryProductLoaded) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllCuisinesScreen(allRecipes: _allRecipesFromBloc),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Recipes are still loading...'),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'See More',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Text(
                      'Scroll left to see more recipes',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 280,
                          child: _buildRecipeList(state),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 28),
              label: '',
            ),
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
      ),
    );
  }

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
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: state.filteredRecipes.length,
        itemBuilder: (context, index) {
          final recipe = state.filteredRecipes[index];
          final bool isFavorite = state.favoriteRecipeIds.contains(recipe.id);
          return FoodCard(
            recipe: recipe,
            isFavorite: isFavorite, // Pass favorite status
            onToggleFavorite: (recipeId) {
              context.read<FoodDeliveryBloc>().add(ToggleFavoriteRecipe(recipeId));
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
      return Center(child: Text(state.message));
    }
    return const SizedBox.shrink();
  }

  Widget _buildProductsShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 180,
            margin: const EdgeInsets.only(right: 22, top: 50, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 60, // Adjusted to match FoodCard image size
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 100,
                  height: 22,
                  child: ColoredBox(color: Colors.white),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 60,
                  height: 20,
                  child: ColoredBox(color: Colors.white),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              width: 80,
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