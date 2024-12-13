import 'package:budget_app/helpers/widgets_helpers.dart';
import 'package:budget_app/widgets/expense/expenses_list/expenses_list.dart';
import 'package:budget_app/widgets/navigations/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/category.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
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

  Period selectedFilter = Period.weekly;

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
          },
        ),
      ),
    );
  }

  void _onPeriodChanged(Period? newFilter) {
    if (newFilter != null) {
      setState(() {
        selectedFilter = newFilter;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses =
        filterExpenses(_registeredExpenses, selectedFilter);
    final groupedExpenses = groupExpensesByDate(filteredExpenses);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transactions",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
              ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.secondary,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.secondary,
              )),
        ],
      ),
      body: Column(
        children: [
          _buildFilterRow(),
          _buildTotalsRow(),
          Expanded(child: _buildExpensesList(groupedExpenses)),
        ],
      ),
      bottomNavigationBar: BottomNavigation(onAddExpense: _addExpense),
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ...Period.values.map(
            (period) => filterPeriodContainer(
              context,
              period.name,
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.onPrimary,
              period,
              selectedFilter,
              _onPeriodChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTotalColumn(
              'Income',
              calculateTotal(Type.income, _registeredExpenses, selectedFilter),
              Theme.of(context).colorScheme.primary),
          _buildTotalColumn(
              'Outcome',
              calculateTotal(Type.outcome, _registeredExpenses, selectedFilter),
              Theme.of(context).colorScheme.error),
          _buildTotalColumn(
              'Total',
              calculateTotal(Type.income, _registeredExpenses, selectedFilter) -
                  calculateTotal(
                      Type.outcome, _registeredExpenses, selectedFilter),
              Colors.black),
        ],
      ),
    );
  }

  Widget _buildTotalColumn(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                )),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildExpensesList(Map<String, Map<String, dynamic>> groupedExpenses) {
    if (groupedExpenses.isEmpty) {
      return const Center(child: Text('No data found'));
    }

    return ExpensesList(
      expenses: _registeredExpenses,
      onRemoveExpense: _removeExpense,
    );
  }
}
