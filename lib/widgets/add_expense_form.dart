import 'package:flutter/material.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddExpenseForm();
  }
}

class _AddExpenseForm extends State<AddExpenseForm> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            maxLength: 50,
            decoration: InputDecoration(label: Text('Amount')),
          ),
        ],
      ),
    );
  }
}
