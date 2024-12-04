import 'package:flutter/material.dart';
import 'package:marketapp/data/category_list.dart';
import 'package:marketapp/widgets/category_card.dart';

class MainGrid extends StatelessWidget {
  const MainGrid({
    super.key,
    required this.categoryList,
    required this.isArabic,
  });

  final CategoryList categoryList;
  final bool isArabic; 
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Two items per row
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
            child: GestureDetector(
              onTap: () {
                print(
                    "get all data of ${category.id} and route to third screen");
              },
              child: CategoryCard(category: category ,isArabic:isArabic),
            ));
      },
    );
  }
}
