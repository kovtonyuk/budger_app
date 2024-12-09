import 'package:flutter/material.dart';
import 'package:budget_app/widgets/expense/expenses.dart';

void main() {
  const kColorScheme = ColorScheme.light(
    primary: Color(0xFF6D31ED),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF9C66F2),
    error: Color(0xFFED3131),
  );

  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: kColorScheme,
        cardTheme: CardTheme(
          color: kColorScheme.onPrimaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.primaryContainer,
                fontSize: 18,
              ),
              titleMedium: TextStyle(
                fontWeight: FontWeight.normal,
                color: kColorScheme.primaryContainer,
                fontSize: 14,
              ),
            ),
      ),
      home: const Expenses(),
    ),
  );
}
