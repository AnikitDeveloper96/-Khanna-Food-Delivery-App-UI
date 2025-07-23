import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Light grey background as per original design
      appBar: AppBar(
        backgroundColor: Colors.grey[50], // Match scaffold background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        centerTitle: false, // Align title to the left
      ),
      body: Column(
        // Use a Column to hold all content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Moved 'My profile' here, inside a Column
          const Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 15.0, // Reduced padding
              left:
                  20.0, // Added left padding to match body's horizontal padding
              right: 20.0, // Added right padding
            ), // Adjust padding as needed
            child: Text(
              'My profile',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          // "Personal details" and "change" in a Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Apply horizontal padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // Align vertically
              children: [
                const Text(
                  'Personal details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle change action
                  },
                  child: const Text(
                    'change',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15), // Spacing below the title row
          // Personal Details Card
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Apply horizontal padding
            child: Card(
              color: Colors.white, // Explicitly white background
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        "assets/images/onboarding_screen_two.png",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Anikit Grover',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 12,
                            thickness: 0.5,
                          ), // Adjusted height
                          Text(
                            'abcd@gmail.com',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 12,
                            thickness: 0.5,
                          ), // Adjusted height
                          Text(
                            '+91 9011039271',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 12,
                            thickness: 0.5,
                          ), // Adjusted height
                          Text(
                            'NA',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing
          // Other Profile Options
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Apply horizontal padding
            child: _buildProfileOption(context, 'Orders', () {
              // Navigate to Orders screen
            }),
          ),
          const SizedBox(height: 8), // Reduced spacing
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Apply horizontal padding
            child: _buildProfileOption(context, 'Faq', () {
              // Navigate to FAQ screen
            }),
          ),
          const SizedBox(height: 8), // Reduced spacing
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ), // Apply horizontal padding
            child: _buildProfileOption(context, 'Help', () {
              // Navigate to Help screen
            }),
          ),
          const Spacer(), // Pushes the Update button to the bottom
          // Update Button - placed outside SingleChildScrollView for sticky behavior
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20.0,
              20.0,
              20.0,
              30.0,
            ), // Padding around the button
            child: SizedBox(
              width: double.infinity, // Make the button take full width
              child: ElevatedButton(
                onPressed: () {
                  // Handle update action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ), // Only vertical padding
                  elevation: 5,
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build consistent profile options
  Widget _buildProfileOption(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      color: Colors.white, // Explicitly white background
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.black,
        ),
        onTap: onTap,
      ),
    );
  }
}
