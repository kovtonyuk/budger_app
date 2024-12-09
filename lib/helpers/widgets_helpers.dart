import 'package:budget_app/models/expense.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

Widget filterPeriodContainer(
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
        'expenses': <Expense>[], // Ініціалізуємо список витрат як List<Expense>
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
