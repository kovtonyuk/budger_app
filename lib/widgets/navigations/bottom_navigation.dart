import 'package:budget_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/widgets/expense/add_expense_form.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openAddExpenseOverlay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseForm(onAddExpense: widget.onAddExpense),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard_customize,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            size: 24,
          ),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: _openAddExpenseOverlay,
            child: Icon(
              Icons.add_circle,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.wallet,
            size: 24,
          ),
          label: 'Budgets',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            size: 24,
          ),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.secondary,
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      elevation: 10, // тінь
    );
  }
}
