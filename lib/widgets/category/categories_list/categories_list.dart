import 'package:flutter/material.dart';

import 'package:budget_app/models/category.dart';
import 'package:budget_app/widgets/category/categories_list/category_item.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.categories,
    required this.onRemovecategory,
  });

  final List<Category> categories;
  final void Function(Category categories) onRemovecategory;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(categories[index]),
          onDismissed: (direction) {
            onRemovecategory(categories[index]);
          },
          child: CategoryItem(categories[index])),
    );
  }
}
