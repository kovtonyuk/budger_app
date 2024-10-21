import 'package:budget_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/category.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  // Функція для визначення кольору на основі типу витрати
  Color _setTypeColor() {
    return expense.type == Type.income
        ? typeColor[Type.income]!
        : typeColor[Type.outcome]!;
  }

  @override
  Widget build(BuildContext context) {
    // Викликаємо функцію для отримання кольору перед рендерингом
    final color = _setTypeColor();
    const colorText = TextStyle(color: Color.fromARGB(255, 255, 255, 255));

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Text(style: colorText, expense.note),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    style: colorText,
                    expense.type.name,
                  ),
                  const Spacer(),
                  Text(
                      style: colorText,
                      '\$${expense.amount.toStringAsFixed(2)}'),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(categoryIcons[expense.category]),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        style: colorText,
                        expense.formattedDate,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
