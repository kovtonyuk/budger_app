import 'package:flutter/material.dart';
import 'package:budget_app/models/category.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(this.category, {super.key});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                //Icon(categoryIcons[category.category]),
                Text(category.title),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
