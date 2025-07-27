// Dummy data model for a cart item
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/appRoutes.dart';

class CartItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Dummy cart items for demonstration
  List<CartItemModel> cartItems = [
    CartItemModel(
      id: '1',
      name: 'Classic Margherita Pizza',
      imageUrl:
          'https://cdn.dummyjson.com/recipe-images/1.webp', // Placeholder image
      price: 1900.00,
      quantity: 1,
    ),
    CartItemModel(
      id: '2',
      name: 'Vegetarian Stir-Fry',
      imageUrl:
          'https://cdn.dummyjson.com/recipe-images/2.webp', // Placeholder image
      price: 1900.00,
      quantity: 1,
    ),
    CartItemModel(
      id: '3',
      name: 'Chocolate Chip Cookies',
      imageUrl:
          'https://cdn.dummyjson.com/recipe-images/3.webp', // Placeholder image
      price: 1900.00,
      quantity: 1,
    ),
  ];

  double get totalAmount {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void _removeItem(String id) {
    setState(() {
      cartItems.removeWhere((item) => item.id == id);
    });
  }

  void _increaseQuantity(String id) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        cartItems[index].quantity++;
      }
    });
  }

  void _decreaseQuantity(String id) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.id == id);
      if (index != -1 && cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else if (index != -1 && cartItems[index].quantity == 1) {
        _removeItem(id); // Remove item if quantity goes to 0
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // "Swipe on an item to delete" instruction
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'swipe on an item to delete',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: cartItems.isEmpty?18:12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key(item.id), // Unique key for Dismissible
                  direction:
                      DismissDirection.endToStart, // Swipe from right to left
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.red, // Red background when swiping
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // Rounded corners
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _removeItem(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.name} removed')),
                    );
                  },
                  child: CartItemCard(
                    item: item,
                    onIncrease: () => _increaseQuantity(item.id),
                    onDecrease: () => _decreaseQuantity(item.id),
                  ),
                );
              },
            ),
          ),
          // Total amount and Complete Order button
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8), // Match background
              // Optional: Add a subtle shadow or border if needed
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cartItems.isEmpty?Container():    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    cartItems.isEmpty?Container(): Text(
                      totalAmount.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (cartItems.isEmpty) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.homeRoute,
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.checkoutPage,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      cartItems.isEmpty ? 'Start Ordering' : 'Complete Order',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable widget for a single cart item
class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemCard({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              10,
            ), // Rounded corners for image
            child: Image.network(
              item.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  '${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35), // Orange price color
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35), // Orange background for quantity
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: onDecrease,
                  child: const Icon(
                    Icons.remove,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item.quantity.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onIncrease,
                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
