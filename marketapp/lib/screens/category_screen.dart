import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marketapp/data/category_list.dart';

class CategoryScreen extends StatefulWidget {
  final bool isArabic;
  const CategoryScreen(
      {super.key, this.isArabic = false, required this.switchScreen});

  final Function switchScreen;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late CategoryList categoryList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  void getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    categoryList = CategoryList();
    await categoryList.fetchCategories();
    // print("============================");
    // print(categoryList.categories.length);
    // Update state to rebuild UI with fetched categories
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: SpinKitWave(
          color: Colors.greenAccent,
          size: 100.0,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: categoryList.categories.length,
      itemBuilder: (context, index) {
        final category = categoryList.categories[index];
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          key: ValueKey(category.id), // Unique key for each category item
          child: GestureDetector(
            onTap: () {
             // print("get all data of ${category.id} and route to third screen");
              widget.switchScreen(index:4, id: category.id);
            },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                    child: Image.asset(
                      category.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error); // Fallback image
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.isArabic ? category.name_ar : category.name_en,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
