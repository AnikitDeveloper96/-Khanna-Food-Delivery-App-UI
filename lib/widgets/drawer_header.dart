import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:fooddeliveryapp/appRoutes.dart'; // Import the package

class CustomAdvancedDrawer extends StatelessWidget {
  final Widget child; // The main screen content
  final AdvancedDrawerController controller;

  const CustomAdvancedDrawer({
    super.key,
    required this.child,
    required this.controller,
  });

  // Helper method to build consistent drawer items
  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isSignOut = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 8.0,
          ),
          leading: Icon(icon, color: Colors.white, size: 28),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSignOut ? 20 : 18, // Slightly larger for sign-out
              fontWeight: isSignOut ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing:
              isSignOut
                  ? const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 28,
                  )
                  : null,
          onTap: onTap,
        ),
        if (!isSignOut)
          // Add a divider after each item except the last (Sign-out)
          Divider(
            color: Colors.white.withOpacity(0.5),
            indent: 20,
            endIndent: 20,
            height: 1, // Minimal height for the divider
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.deepOrange, // Background color when drawer is open
      controller: controller,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      child: child, // The main screen content passed from HomeScreen
      drawer: SafeArea(
        child: Container(
          color:
              Colors.deepOrange, // This will be the color of the drawer content
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    right: 10.0,
                    left: 20,
                    bottom: 20,
                  ),
                  child: CircleAvatar(
                    // Added CircleAvatar for the circular background
                    backgroundColor: Colors.white, // White background
                    radius: 20, // Adjust radius as needed to fit the icon
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color:
                            Colors
                                .deepOrange, // Changed icon color for contrast
                        size: 24, // Adjusted size to fit well within the circle
                      ),
                      onPressed: () {
                        controller.hideDrawer(); // Close the drawer
                      },
                    ),
                  ),
                ),
              ),
              // Original spacing (can be adjusted after adding close icon)
              // const SizedBox(height: 80.0), // Removed as close icon takes space
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildDrawerItem(Icons.person_outline, 'Profile', () {
                      Navigator.pushNamed(context, AppRoutes.myProfile);
                    }),
                    _buildDrawerItem(Icons.shopping_bag_outlined, 'Orders', () {
                      Navigator.pushNamed(context, AppRoutes.myorders);
                    }),
                    _buildDrawerItem(
                      Icons.bookmark_border,
                      'Offer and Promo',
                      () {
                        Navigator.pushNamed(context, AppRoutes.myOffers);
                      },
                    ),
                  ],
                ),
              ),
              // Sign-out Button at the bottom of the drawer
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 30.0, // More padding from the bottom
                ),
                child: _buildDrawerItem(Icons.logout, 'Sign-out', () {
                  controller.hideDrawer(); // Close the drawer
                  // Handle sign-out logic
                }, isSignOut: true),
              ),
            ],
          ),
        ),
      ),
      openScale: 0.9,
      openRatio: 0.6,
    );
  }
}
