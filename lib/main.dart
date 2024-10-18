import 'package:flutter/material.dart';
import 'package:budget_app/widgets/expense/expenses.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(useMaterial3: true), home: const Expenses()));
}
