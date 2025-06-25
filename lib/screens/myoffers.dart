import 'package:flutter/material.dart';

class MyOffers extends StatelessWidget {
  const MyOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Colors.grey[50], // Light grey background as per original design
      appBar: AppBar(
        backgroundColor: Colors.grey[50], // Match scaffold background
        elevation: 0,
        leading: IconButton( // Added a back button for navigation
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Align content to the start vertically
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start horizontally
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 15.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Text(
              'My Offers',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          Expanded( // Use Expanded to push the centered content to fill available space
            child: Center( // Center the content both horizontally and vertically
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center children vertically within this Column
                crossAxisAlignment: CrossAxisAlignment.center, // Center children horizontally within this Column
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 20.0,
                    ),
                    child: Text(
                      'ohh snap! No offers yet !',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 20.0,
                      left: 20.0, // Added horizontal padding for text wrapping
                      right: 20.0, // Added horizontal padding for text wrapping
                    ),
                    child: Text(
                      'You doesn\'t have any offers right now , try again later',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                      ),
                      maxLines: 3, // Increased maxLines to prevent overflow if text is long
                      textAlign: TextAlign.center, // Center the text within its own bounds
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
