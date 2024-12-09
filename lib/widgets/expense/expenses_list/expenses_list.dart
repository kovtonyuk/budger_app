import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/widgets/expense/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          key: Key(expenses[index].id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => onRemoveExpense(expenses[index]),
          child: ExpenseItem(expenses[index]),
        );
      },
    );
  }
}
