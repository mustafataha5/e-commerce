import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marketapp/data/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:marketapp/screens/main_screen.dart';

class CartScreen extends StatefulWidget {
  final List<Item> initialCart;
  final Function switchScreen;
  final Function addQuantityToCart;
  final Function removeQuantityFromCart;
  final Function removeFromCart;
  final Function clearAllCart;
  const CartScreen({
    super.key,
    required this.initialCart,
    required this.switchScreen,
    required this.addQuantityToCart,
    required this.removeQuantityFromCart,
    required this.removeFromCart,
    required this.clearAllCart,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Item> cart;
  late dynamic order;
  late FlutterSecureStorage storage;
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  void initState() {
    super.initState();
    cart = widget.initialCart;
    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  double calculateTotalPrice() {
    return cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void makeOrder() async {
    // Retrieve the JWT token from secure storage
    String? jwtToken = await storage.read(key: 'accessToken');

    if (jwtToken == null) {
      // Handle case where JWT is missing (e.g., user not logged in)
      print("JWT token is missing. User not authenticated.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // Handle empty cart scenario
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing can order')),
      );
      return;
    }

    // Construct the order items
    final orderItems = cart.map((item) {
      return {
        'itemId': item.itemId,
        'quantity': item.quantity,
      };
    }).toList();

    // Retrieve the userId from secure storage
    String? userId = await storage.read(key: 'userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
      return;
    }

    final orderData = {
      'userId': userId,
      'items': orderItems,
      // 'orderDate': DateTime.now().toIso8601String(), // Add order date
      'status': 'Pending', // Optional: you can default the status to 'Pending'
    };

    try {
      // Send the POST request with the JWT token in the headers
      final response = await http.post(
        Uri.parse('http://192.168.1.17:8001/api/mobileorders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken', // Include JWT token here
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        // Handle successful order
        final data = jsonDecode(response.body);
        widget.clearAllCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully')),
        );
        Navigator.pushReplacementNamed(context, MainScreen.id);
        // You can navigate or reset the cart here if needed
      } else {
        // Handle failure scenario
        final error = jsonDecode(response.body)['message'] ?? 'Order failed';
       // print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      // Handle any errors during the API request
      //print('Error making order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to place order. Try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return cart.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  "Your cart is empty!",
                  style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => widget.switchScreen(index: 0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  child: const Text("Shop Now"),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.imageUrl,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Price: ${item.price.toStringAsFixed(2)} ₪",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.removeQuantityFromCart(
                                              item.itemId);
                                        });
                                      },
                                      icon: const Icon(Icons.remove_circle,
                                          color: Colors.red),
                                    ),
                                    Text(
                                      "${item.quantity}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (item.quantity < item.limit) {
                                            widget
                                                .addQuantityToCart(item.itemId);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "You limit  to ${item.limit} for this item ${item.name} "),
                                            ));
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.removeFromCart(item.itemId);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${calculateTotalPrice().toStringAsFixed(2)} ₪",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Implement checkout logic
                        makeOrder();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text("Proceeding to checkout..."),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
