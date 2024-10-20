import 'package:flutter/material.dart';
import 'package:budget_app/models/category.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({super.key, required this.onAddCategory});

  final void Function(Category newCategory) onAddCategory;

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

      widget.onAddCategory(
        Category(
          title: enteredTitle,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added successfully')),
      );

      if (enteredTitle.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a title')),
        );
        return;
      }

      _formKey.currentState!.reset();

      _categoryController.clear();
      Navigator.pop(context);
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
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Category name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
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
