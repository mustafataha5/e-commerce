import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marketapp/data/category.dart';

class CategoryList {
  final List<Category> categories = [];
  List<dynamic> data = [];

  Future<void> fetchCategories() async {
    try {
      // Try localhost for emulator testing
     // print("================================");
      final uri = Uri.parse(
          "http://192.168.1.17:8001/api/categories"); // Use the correct IP here
      final response = await http.get(uri);
      //print("================================>>>>>>>>>>");
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        data = jsonResponse['categories'];
        createCategories();
      } else {
        print("Failed to load categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void createCategories() {
    categories.clear(); // Clear existing categories
    for (var item in data) {
      categories.add(Category(
        id: item['_id'],
        name_en: item['name_en'],
        name_ar: item['name_ar'],
        image:
            "assets/img/${item['name_en'].replaceAll(' & ', '_').replaceAll(' ', '_')}.jpg", // Assuming images are named by the English category name
      ));
    }
  }
}
