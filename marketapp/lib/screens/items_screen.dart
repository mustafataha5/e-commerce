import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketapp/data/item.dart';

class ItemsScreen extends StatefulWidget {
  static const String id = "item_screen";

  const ItemsScreen({
    super.key,
    required this.categoryId,
    required this.chart,
    required this.addToChart,
    required this.addQuantityToChart,
    required this.removeQuantityFromChart,
    this.isArabic = false,
    required this.switchScreen,
  });

  final bool isArabic;
  final String categoryId;
  final List<dynamic> chart;
  final Function addToChart;
  final Function addQuantityToChart;
  final Function removeQuantityFromChart;
  final Function switchScreen;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<dynamic> items = [];

  Future<void> getItems() async {
    try {
      final uri = Uri.parse(
          "http://192.168.1.17:8001/api/items/category/${widget.categoryId}");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          items = jsonResponse['items'];
        });
      } else {
        print("Failed to load items: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        final crossAxisCount = isWideScreen ? 4 : 2;
        final itemHeight = isWideScreen ? 250 : 200;

        return items.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: isWideScreen ? 1.2 : 0.8,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final existingItemInCart = widget.chart.any(
                    (cartItem) => cartItem.itemId == item['_id'],
                  );
                  var quantity = 0;
                  if (existingItemInCart) {
                    var currentItem = widget.chart.firstWhere(
                      (cartItem) => cartItem.itemId == item['_id'],
                    );
                    quantity = currentItem.quantity;
                  }

                  return Card(
                    elevation: 8,
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15.0),
                            ),
                            child: Stack(
                              children: [
                                Image.network(
                                  item['imageUrl'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: itemHeight.toDouble(),
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.error,
                                          color: Colors.red, size: 50),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "${item['price']} ₪",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.isArabic
                                    ? item['name_ar']
                                    : item['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                width: double.infinity,
                                child: item['availableNum'] > 0 &&
                                        existingItemInCart == false
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            widget.addToChart(
                                              Item(
                                                itemId: item['_id'],
                                                name: item['name'],
                                                price: item['price'],
                                                availableNum:
                                                    item['availableNum'],
                                                limit: item['limit'],
                                                nameAr: item['name_ar'],
                                                imageUrl: item['imageUrl'],
                                              ),
                                            );
                                          });
                                        },
                                        child: const Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // RoundButton(
                                          //   icon: Icons.remove,
                                          //   toDo: () {
                                          //     setState(() {
                                          //       widget
                                          //           .removeQuantityFromChart(
                                          //               item['_id']);
                                          //     });
                                          //   },
                                          // ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.removeQuantityFromChart(
                                                    item['_id']);
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.red),
                                          ),
                                          //const SizedBox(width: 2),
                                          Text(
                                            " $quantity / ${item['limit']} (${item['availableNum']}) ",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          //  const SizedBox(width: 2),
                                          // RoundButton(
                                          //   icon: Icons.add,
                                          //   toDo: () {
                                          //     setState(() {
                                          //       widget.addQuantityToChart(
                                          //           item['_id']);
                                          //     });
                                          //   },
                                          // ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (quantity < item['limit']) {
                                                  widget.addQuantityToChart(
                                                      item['_id']);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          "You limit  to ${item['limit']} for this item ${item['name']} "),
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            icon: const Icon(Icons.add_circle,
                                                color: Colors.green),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Center(child: Text("Items not available"));
      },
    );
  }
}
