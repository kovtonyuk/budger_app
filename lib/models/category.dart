import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum BaseCategory { food, travel, leisure, work }

const categoryIcons = {
  BaseCategory.food: Icons.lunch_dining,
  BaseCategory.travel: Icons.flight_takeoff,
  BaseCategory.leisure: Icons.movie,
  BaseCategory.work: Icons.work,
};

class Category {
  Category({
    required this.title,
    //required this.category, // Додано поле для зберігання типу BaseCategory
  }) : id = uuid.v4();

  final String title;
  //final BaseCategory category; // Додано поле category
  final String id;
}
