import 'package:budget_app/widgets/category/categories.dart';
import 'package:budget_app/helpers/widgets_helpers.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/category.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({
    super.key,
    required this.onAddExpense,
  });

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
  // final Type _typeController = Type.income;
  DateTime? _selectedDate;
  Category? _selectedCategory;
  Currency _selectedCurrency = Currency.usd;
  final Account _selectedAccount = Account.card;
  final _formKey = GlobalKey<FormState>();
  Type _selectedType = Type.income;

  // final List<Category> _customCategories =
  //     []; // Зберігаємо категорії, створені користувачем

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
        return;
      }

      //Використовуємо _selectedCategory з перевіркою на null
      final category = _selectedCategory ??
          Category(
              title: BaseCategory.food
                  .name); // Використовуємо базову категорію за замовчуванням

      widget.onAddExpense(Expense(
        type: _selectedType,
        amount: enteredAmount,
        currency: _selectedCurrency,
        category: category,
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

  // Відкриття сторінки з категоріями
  void _openCategoriesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Categories(),
      ),
    );
  }

  // Method to handle type changes
  void _onTypeChanged(Type? newType) {
    // Change to accept Type?
    if (newType != null) {
      // Check for null
      setState(() {
        _selectedType = newType;
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add expense"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPeriodContainer(
                  'Income',
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                  //const Color.fromARGB(255, 34, 173, 18),
                  //const Color(0xFFF5F1FE),
                  Type.income,
                  _selectedType,
                  _onTypeChanged, // Pass the updated method
                ),
                const SizedBox(
                  width: 8,
                ),
                buildPeriodContainer(
                  'Outcome',
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                  Type.outcome,
                  _selectedType,
                  _onTypeChanged, // Pass the updated method
                ),
              ],
            ),
          ),
          Form(
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
                            prefixText:
                                '${_selectedCurrency.name.toUpperCase()} ',
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
                      ElevatedButton(
                        onPressed: _openCategoriesPage,
                        child: Text(
                          _selectedCategory == null
                              ? 'Select Category'
                              : _selectedCategory!.name.toUpperCase(),
                        ),
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
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
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
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
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
          ),
        ],
      ),
    );
  }
}
