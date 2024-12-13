import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';
import 'package:budget_app/models/category.dart';
import 'package:budget_app/helpers/widgets_helpers.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  BaseCategory? _getBaseCategoryFromTitle(String title) {
    try {
      return BaseCategory.values
          .firstWhere((category) => category.name == title);
    } catch (e) {
      return null; // Return null if category not found
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getTypeColor(context, expense.type);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: _buildTitle(context),
              subtitle: _buildSubtitle(context),
              trailing: _buildTrailing(context),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildTitle(BuildContext context) {
    return Row(
      children: [
        Icon(
          categoryIcons[_getBaseCategoryFromTitle(expense.category.title)] ??
              Icons.help_outline,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            expense.category.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ),
      ],
    );
  }

  Padding _buildSubtitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const SizedBox(width: 32),
          Expanded(
            child: Text(
              expense.note,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Text _buildTrailing(BuildContext context) {
    return Text(
      '\$${expense.amount.toStringAsFixed(2)}',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
    );
  }
}
