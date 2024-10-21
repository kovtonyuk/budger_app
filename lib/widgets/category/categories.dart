import 'package:budget_app/widgets/category/categories_list/categories_list.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/category.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() {
    return _CategoriesState();
  }
}

class _CategoriesState extends State<Categories> {
  final List<Category> _registeredCategories = [
    Category(
      title: 'Test',
    ),
  ];

  void _addCategory(Category category) {
    setState(() {
      _registeredCategories.add(category);
    });
  }

  // void _openCreateCategoryForm() {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('Create New Category'),
  //       content: TextField(
  //         decoration: const InputDecoration(labelText: 'Category name'),
  //         onSubmitted: (value) {
  //           Navigator.pop(ctx);
  //         },
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(ctx);
  //           },
  //           child: const Text('Cancel'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(ctx);
  //           },
  //           child: const Text('Save'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _removeCategory(Category category) {
    final categoryIndex = _registeredCategories.indexOf(category);
    setState(() {
      _registeredCategories.remove(category);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Category deleted.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredCategories.insert(categoryIndex, category);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No data found'),
    );

    if (_registeredCategories.isNotEmpty) {
      mainContent = CategoriesList(
        categories: _registeredCategories,
        onRemovecategory: _removeCategory,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            // onPressed: _openCreateCategoryForm,
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
