import 'package:budget_app/helpers/widgets_helpers.dart';
import 'package:budget_app/widgets/expense/expenses_list/expenses_list.dart';
import 'package:budget_app/widgets/navigations/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Period _selectedFilter = Period.weekly;

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
        _selectedFilter = newFilter;
      });
    }
  }

  double _calculateTotal(Type type) {
    final filteredExpenses = _filterExpenses(_registeredExpenses);
    return filteredExpenses
        .where((expense) => expense.type == type)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  List<Expense> _filterExpenses(List<Expense> expenses) {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case Period.day:
        return expenses.where((expense) {
          return expense.date.day == now.day &&
              expense.date.month == now.month &&
              expense.date.year == now.year;
        }).toList();
      case Period.monthly:
        return expenses.where((expense) {
          return expense.date.month == now.month &&
              expense.date.year == now.year;
        }).toList();
      case Period.weekly:
        final startOfWeek = now.subtract(Duration(days: now.weekday));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return expenses.where((expense) {
          return (expense.date.isAfter(startOfWeek) ||
                  expense.date.isAtSameMomentAs(startOfWeek)) &&
              (expense.date.isBefore(endOfWeek.add(Duration(days: 1))) ||
                  expense.date.isAtSameMomentAs(endOfWeek));
        }).toList();
      case Period.year:
        return expenses.where((expense) {
          return expense.date.year == now.year;
        }).toList();
      default:
        return expenses;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _filterExpenses(_registeredExpenses);
    final groupedExpenses = groupExpensesByDate(filteredExpenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          _buildFilterRow(),
          _buildTotalsRow(),
          Expanded(child: _buildExpensesList(groupedExpenses)),
          const Text('Show more'),
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
              period.name,
              const Color(0xFF6D31ED),
              const Color(0xFFF5F1FE),
              period,
              _selectedFilter,
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
              'Income', _calculateTotal(Type.income), const Color(0xFF6D31ED)),
          _buildTotalColumn('Outcome', _calculateTotal(Type.outcome),
              const Color.fromARGB(255, 237, 49, 49)),
          _buildTotalColumn(
              'Total',
              _calculateTotal(Type.income) - _calculateTotal(Type.outcome),
              Colors.black),
        ],
      ),
    );
  }

  Widget _buildTotalColumn(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold, fontSize: 11, color: color),
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
