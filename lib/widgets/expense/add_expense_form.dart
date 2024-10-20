import 'package:budget_app/widgets/category/add_category_form.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/category.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _AddExpenseForm();
  }
}

class _AddExpenseForm extends State<AddExpenseForm> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _placeController = TextEditingController();
  DateTime? _selectedDate;
  BaseCategory? _selectedCategory; // Зміна на nullable
  Currency _selectedCurrency = Currency.usd;
  Account _selectedAccount = Account.card;
  final _formKey = GlobalKey<FormState>();

  final List<Category> _customCategories =
      []; // Зберігаємо категорії, створені користувачем

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickDate;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final enteredAmount = double.tryParse(_amountController.text);
      if (enteredAmount == null || enteredAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      // Використовуємо _selectedCategory з перевіркою на null
      final category = _selectedCategory ??
          BaseCategory
              .food; // Встановлюємо стандартну категорію, якщо _selectedCategory є null

      widget.onAddExpense(Expense(
        amount: enteredAmount,
        currency: _selectedCurrency,
        category: category, // Тепер category - тип BaseCategory
        account: _selectedAccount,
        note: _noteController.text,
        date: _selectedDate!,
        place: _placeController.text,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
        _selectedCategory = null; // Скидаємо вибрану категорію
      });

      Navigator.pop(context);
    }
  }

  void _addCategory(Category newCategory) {
    setState(() {
      _customCategories.add(newCategory); // Додаємо нову категорію до списку
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    maxLength: 30,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '${_selectedCurrency.name.toUpperCase()} ',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 20),
                DropdownButton<Currency>(
                  value: _selectedCurrency,
                  items: Currency.values.map((Currency currency) {
                    return DropdownMenuItem<Currency>(
                      value: currency,
                      child: Text(currency.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (Currency? newValue) {
                    setState(() {
                      _selectedCurrency = newValue!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Category:'),
                DropdownButton<BaseCategory?>(
                  value: _selectedCategory,
                  items: [
                    ...BaseCategory.values.map((BaseCategory category) {
                      return DropdownMenuItem<BaseCategory>(
                        value: category,
                        child: Row(
                          children: [
                            Icon(categoryIcons[
                                category]), // Додаємо іконку категорії
                            const SizedBox(width: 8),
                            Text(category.name.toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                    // Додаємо нові категорії
                    ..._customCategories.map((Category category) {
                      return DropdownMenuItem<BaseCategory>(
                        value: BaseCategory.values.firstWhere(
                            (e) => e.name == category.title.toLowerCase(),
                            orElse: () => BaseCategory
                                .food), // Використовуйте правильну логіку
                        child: Text(category.title),
                      );
                    }).toList(),
                    const DropdownMenuItem<BaseCategory?>(
                      value: null,
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text('Add category'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (BaseCategory? newValue) {
                    if (newValue == null) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Create New Category'),
                          content: AddCategoryForm(
                            onAddCategory: _addCategory,
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        _selectedCategory =
                            newValue; // Встановлюємо вибрану категорію
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            FormField<DateTime>(
              validator: (value) {
                if (_selectedDate == null) {
                  return 'Please select a date';
                }
                return null;
              },
              builder: (FormFieldState<DateTime> field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : _selectedDate!.toString(),
                          style: TextStyle(
                            color: field.hasError
                                ? const Color.fromRGBO(178, 40, 30, 1)
                                : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: const TextStyle(
                            color: Color.fromRGBO(178, 40, 30, 1)),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a note';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Expense'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
