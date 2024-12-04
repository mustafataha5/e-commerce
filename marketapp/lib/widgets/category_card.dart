
import 'package:flutter/material.dart';
import 'package:marketapp/data/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.isArabic,
  });

  final Category category;
  final bool isArabic ; 
  @override
  Widget build(BuildContext context) {
    return Column(
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
                return const Icon(Icons.error); // Fallback image on error
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            isArabic ? category.name_ar : category.name_en,
            maxLines: 1, // Allow up to 2 lines of text
            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
            style: const TextStyle(
              fontSize: 14, // Reduce font size slightly
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
