import 'package:flutter/material.dart';
import 'package:budget_app/models/category.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({
    super.key,
    required this.onAddCategory,
    required this.existingCategories,
  });

  final void Function(Category newCategory) onAddCategory;
  final List<String> existingCategories; // Список існуючих категорій

  @override
  State<AddCategoryForm> createState() {
    return _AddCategoryForm();
  }
}

class _AddCategoryForm extends State<AddCategoryForm> {
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitCategory() {
    if (_formKey.currentState!.validate()) {
      final enteredTitle = _categoryController.text;

      final newCategory = Category(
        title: enteredTitle,
      );

      widget
          .onAddCategory(newCategory); // Додаємо нову категорію через callback

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added successfully')),
      );

      _formKey.currentState!.reset();
      _categoryController.clear();

      //Navigator.pop(context); // Закриваємо модалку
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Прозорий фон
                  elevation: 0, // Без тіні
                ),
                onPressed: () {
                  Navigator.pop(
                      context); // Закриваємо модалку без передачі даних
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Category name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              // Перевірка, чи існує категорія з таким же ім'ям
              if (widget.existingCategories.contains(value)) {
                return 'Category already exists';
              }
              // Перевірка наявності в enum
              if (BaseCategory.values
                  .map((e) => e.name)
                  .contains(value.toLowerCase())) {
                return 'Category already exists';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitCategory,
            child: const Text('Save Category'),
          ),
        ],
      ),
    );
  }
}
