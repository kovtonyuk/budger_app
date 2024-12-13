import 'package:budget_app/models/expense.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

//using on add expense page
Widget buildPeriodContainer(
  String label,
  Color backgroundColor,
  Color textColor,
  Type type,
  Type selectedType,
  ValueChanged<Type?> onChanged,
) {
  return Expanded(
    child: GestureDetector(
      onTap: () => onChanged(type), // Передайте тип при натисканні
      child: Container(
        width: 70,
        height: 40,
        decoration: BoxDecoration(
            color: selectedType == type
                ? backgroundColor
                : const Color(0xFFF5F1FE),
            borderRadius: BorderRadius.circular(8), // Заокруглені краї
            border: Border.all(color: const Color(0xFF6D31ED), width: 2)),
        child: Center(
          // Вирівнюємо текст по центру
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: selectedType == type ? textColor : const Color(0xFF6D31ED),
            ),
          ),
        ),
      ),
    ),
  );
}

//using on Expenses page
Widget filterPeriodContainer(
  BuildContext context,
  String label,
  Color backgroundColor,
  Color textColor,
  Period period,
  Period selectedFilter,
  ValueChanged<Period?> onChanged,
) {
  return Expanded(
    child: GestureDetector(
      onTap: () => onChanged(period),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: 80,
          height: 28,
          decoration: BoxDecoration(
              color: selectedFilter == period
                  ? backgroundColor
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              const Icon(Icons.abc),
              Center(
                child: Text(
                  capitalizeEnumValue(period),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: selectedFilter == period
                            ? textColor
                            : Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget filterAmountPeriodContainer(
  String label,
  Color backgroundColor,
  Color textColor,
  Period period,
  Period selectedFilter,
  ValueChanged<Period?> onChanged,
) {
  return Expanded(
    child: GestureDetector(
      onTap: () => onChanged(period), // Передайте тип при натисканні
      child: Container(
        width: 70,
        height: 40,
        decoration: BoxDecoration(
            color: selectedFilter == period
                ? backgroundColor
                : const Color(0xFFF5F1FE),
            borderRadius: BorderRadius.circular(8), // Заокруглені краї
            border: Border.all(color: const Color(0xFF6D31ED), width: 2)),
        child: Center(
          // Вирівнюємо текст по центру
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: selectedFilter == period
                  ? textColor
                  : const Color(0xFF6D31ED),
            ),
          ),
        ),
      ),
    ),
  );
}

Map<String, Map<String, dynamic>> groupExpensesByDate(List<Expense> expenses) {
  Map<String, Map<String, dynamic>> groupedExpenses = {};

  for (var expense in expenses) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(expense.date);

    if (!groupedExpenses.containsKey(formattedDate)) {
      groupedExpenses[formattedDate] = {
        'expenses': <Expense>[],
        'totalIncome': 0.0,
        'totalOutcome': 0.0,
      };
    }

    groupedExpenses[formattedDate]!['expenses'].add(expense);

    if (expense.type == Type.income) {
      groupedExpenses[formattedDate]!['totalIncome'] += expense.amount;
    } else if (expense.type == Type.outcome) {
      groupedExpenses[formattedDate]!['totalOutcome'] += expense.amount;
    }
  }

  return groupedExpenses;
}

// Функція для визначення кольору на основі типу витрати
Color getTypeColor(BuildContext context, Type type) {
  final colorScheme = Theme.of(context).colorScheme;
  return type == Type.income ? colorScheme.primary : colorScheme.error;
}

double calculateTotal(Type type, registeredExpenses, dynamic selectedFilter) {
  final filteredExpenses = filterExpenses(registeredExpenses, selectedFilter);
  return filteredExpenses
      .where((expense) => expense.type == type)
      .fold(0.0, (sum, item) => sum + item.amount);
}

List<Expense> filterExpenses(List<Expense> expenses, selectedFilter) {
  final now = DateTime.now();
  switch (selectedFilter) {
    case Period.day:
      return expenses.where((expense) {
        return expense.date.day == now.day &&
            expense.date.month == now.month &&
            expense.date.year == now.year;
      }).toList();
    case Period.monthly:
      return expenses.where((expense) {
        return expense.date.month == now.month && expense.date.year == now.year;
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

// Функція для переведення значення enum в "Capitalize"
String capitalizeEnumValue(Enum enumValue) {
  String text = enumValue.toString().split('.').last;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
