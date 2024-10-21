import 'package:budget_app/helpers/widgets_helpers.dart';
import 'package:budget_app/widgets/navigations/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/widgets/expense/expenses_list/expenses_list.dart';
import 'package:budget_app/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:budget_app/models/category.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        type: Type.income,
        amount: 20.00,
        currency: Currency.usd,
        category: Category(title: BaseCategory.food.name),
        account: Account.cash,
        date: DateTime.now(),
        place: 'place',
        note: 'Pizza'),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  double get totalIncome {
    return _registeredExpenses
        .where((expense) => expense.type == Type.income)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalOutcome {
    return _registeredExpenses
        .where((expense) => expense.type == Type.outcome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get total => totalIncome - totalOutcome;

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No data found'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildPeriodContainer(
                    'Days', const Color(0xFF6D31ED), Colors.white),
                const SizedBox(
                  width: 8,
                ),
                buildPeriodContainer(
                    'Weekly', const Color(0xFFF5F1FE), const Color(0xFF6D31ED)),
                const SizedBox(
                  width: 8,
                ),
                buildPeriodContainer('Monthly', const Color(0xFFF5F1FE),
                    const Color(0xFF6D31ED)),
                const SizedBox(
                  width: 8,
                ),
                buildPeriodContainer(
                    'Year', const Color(0xFFF5F1FE), const Color(0xFF6D31ED)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Income'),
                    Text(
                      '\$${totalIncome.toStringAsFixed(2)}', // Використовуємо totalIncome
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: const Color(0xFF6D31ED)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Outcome'),
                    Text(
                      '\$${totalOutcome.toStringAsFixed(2)}', // Використовуємо totalOutcome
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: const Color.fromARGB(255, 237, 49, 49),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text('Total'),
                    Text(
                      '\$${total.toStringAsFixed(2)}', // Використовуємо total
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: mainContent,
          ),
          const Text('Show more'),
        ],
      ),
      bottomNavigationBar: BottomNavigation(onAddExpense: _addExpense),
    );
  }
}
