import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMMMMEEEEd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }

enum Currency { usd, eur, uah }

enum Account { card, cash }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

const accountIcons = {
  Account.card: Icons.credit_card,
  Account.cash: Icons.monetization_on_outlined,
};

class Expense {
  Expense({
    required this.amount,
    required this.currency,
    required this.category,
    required this.account,
    required this.note,
    required this.date,
    required this.place,
  }) : id = uuid.v4();

  final double amount;
  final Currency currency;
  final Category category;
  final Account account;
  final String note;
  final DateTime date;
  final String id;
  final String place;

  String get formattedDate {
    return formatter.format(date);
  }
}
