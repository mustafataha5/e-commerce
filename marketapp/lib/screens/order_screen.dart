import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderScreen extends StatefulWidget {
  static const String id = "order_screen";
  final Function switchScreen;
  const OrderScreen({super.key, required this.switchScreen});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool loading = true;
  List<dynamic> orders = [];
  late FlutterSecureStorage storage;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  void getOrders() async {
    String? jwtToken = await storage.read(key: 'accessToken');
    if (jwtToken == null) {
      print("JWT token is missing. User not authenticated.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      setState(() {
        loading = false;
      });
      return;
    }

    String? userId = await storage.read(key: 'userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
      setState(() {
        loading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.17:8001/api/mobileorders/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['orders'][0]);
        setState(() {
          orders =
              data['orders']; // Assuming 'orders' is the key in the response
          loading = false;
        });
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Order failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get orders list.')),
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        backgroundColor: Colors.greenAccent,
        elevation: 0,
      ),
      body: loading
          ? const Center(
              child: SpinKitWave(
                color: Colors.greenAccent,
                size: 100.0,
              ),
            )
          : orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delivery_dining_sharp,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "You have no orders yet!",
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => widget.switchScreen(index: 0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                        ),
                        child: const Text("Shop Now"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_cart,
                          color: Colors.greenAccent,
                        ),
                        title: Text("Order #${order['orderDate']}"),
                        subtitle: Text("Status: ${order['status']}"),
                        trailing: Text("${order['totalPrice']} ₪"),
                        onTap: () {
                          // Navigate to detailed order view
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
