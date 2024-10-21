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
    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (ctx) => AddExpenseForm(onAddExpense: widget.onAddExpense));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard_customize,
            size: 20,
          ),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            size: 20,
          ),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: _openAddExpenseOverlay,
            child: const Icon(
              Icons.add_circle,
              size: 42,
              color: Color(0xFF6D31ED),
            ),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.wallet,
            size: 20,
          ),
          label: 'Budgets',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFF6D31ED),
      unselectedItemColor: const Color(0xFF565D6D),
      backgroundColor: Colors.white,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      elevation: 10, // тінь
    );
  }
}
