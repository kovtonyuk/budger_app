import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';

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
  final _placeControler = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;
  Currency _selectedCurrency = Currency.usd;
  Account _selectedAccount = Account.card;

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

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amoutIsValid = enteredAmount == null || enteredAmount <= 0;
    if (_noteController.text.trim().isEmpty ||
        amoutIsValid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid input'),
                content: const Text('Please enter valid data'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  )
                ],
              ));
      return;
    }
    widget.onAddExpense(Expense(
        amount: enteredAmount,
        currency: _selectedCurrency,
        category: _selectedCategory,
        account: _selectedAccount,
        note: _noteController.text,
        date: _selectedDate!,
        place: _placeControler.text));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    // prefixText: '\$ ',
                    prefix: Text('${_selectedCurrency.name.toUpperCase()} '),
                    label: const Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(
                width: 32,
              ),
              DropdownButton(
                  value: _selectedCurrency,
                  items: Currency.values
                      .map(
                        (currency) => DropdownMenuItem(
                            value: currency,
                            child: Text(
                              currency.name.toUpperCase(),
                            )),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCurrency = value;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Choose category'),
              const Spacer(),
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            )),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
            ],
          ),
          Row(
            children: [
              Text(_selectedDate == null
                  ? 'No date selected'
                  : formatter.format(_selectedDate!)),
              IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(Icons.calendar_month)),
            ],
          ),
          TextField(
            controller: _noteController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text('Note'),
            ),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: _submitExpenseData,
                  child: const Text('Save Expense'))
            ],
          )
        ],
      ),
    );
  }
}
