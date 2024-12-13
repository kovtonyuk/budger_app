import 'package:flutter/material.dart';
import 'package:budget_app/widgets/expense/expenses.dart';

void main() {
  const kColorScheme = ColorScheme.light(
    primary: Color(0xFF6D31ED),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF9C66F2),
    onPrimaryContainer: Colors.white,
    secondary: Color(0xFF565D6D),
    tertiary: Color(0xFFF5F1FE),
    tertiaryContainer: Color.fromARGB(255, 0, 0, 0),
    error: Color(0xFFED3131),
    onError: Colors.white,
  );

  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: kColorScheme,
        cardTheme: CardTheme(
          color: kColorScheme.primaryContainer,
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
                color: kColorScheme.onPrimary,
                fontSize: 18,
              ),
              titleMedium: TextStyle(
                fontWeight: FontWeight.normal,
                color: kColorScheme.onPrimaryContainer,
                fontSize: 14,
              ),
              titleSmall: TextStyle(
                fontWeight: FontWeight.normal,
                color: kColorScheme.onPrimaryContainer,
                fontSize: 12,
              ),
            ),
        iconTheme: IconThemeData(color: kColorScheme.onPrimary),
      ),
      home: const Expenses(),
    ),
  );
}
