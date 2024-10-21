import 'package:budget_app/helpers/widgets_helpers.dart';
import 'package:budget_app/widgets/navigations/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:budget_app/models/expense.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:budget_app/models/category.dart';
import 'package:intl/intl.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        type: Type.income,
        amount: 20.00,
        currency: Currency.usd,
        category: Category(title: BaseCategory.food.name),
        account: Account.cash,
        date: DateTime.now(),
        place: 'place',
        note: 'Pizza'),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  double get totalIncome {
    return _registeredExpenses
        .where((expense) => expense.type == Type.income)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalOutcome {
    return _registeredExpenses
        .where((expense) => expense.type == Type.outcome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get total => totalIncome - totalOutcome;

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No data found'),
    );

    if (_registeredExpenses.isNotEmpty) {
      Map<String, Map<String, dynamic>> groupedExpenses =
          groupExpensesByDate(_registeredExpenses);

      mainContent = ListView.builder(
        itemCount: groupedExpenses.keys.length,
        itemBuilder: (ctx, index) {
          String date = groupedExpenses.keys.elementAt(index);
          // List<Expense> expensesByDate = groupedExpenses[date]!;
          List<Expense> expensesByDate = groupedExpenses[date]!['expenses'];
          double totalIncomeByDate = groupedExpenses[date]!['totalIncome'];
          double totalOutcomeByDate = groupedExpenses[date]!['totalOutcome'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Відображення дати
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat.MMMd().format(DateTime.parse(date)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${totalIncomeByDate.toStringAsFixed(2)}', // Доходи за цей день
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: const Color(0xFF6D31ED)),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          '\$${totalOutcomeByDate.toStringAsFixed(2)}', // Витрати за цей день
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: const Color.fromARGB(255, 237, 49, 49),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              ...expensesByDate.map((expense) {
                Color color = setTypeColor(expense);
                return Dismissible(
                  key: Key(expense.id
                      .toString()), // Унікальний ключ для кожної витрату
                  direction: DismissDirection.endToStart, // Напрямок свайпу
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    // Викликаємо ваш метод видалення
                    _removeExpense(expense);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            expense.note),
                        subtitle: Text(
                            style: GoogleFonts.manrope(
                                color: Colors.white, fontSize: 12),
                            expense.category.title),
                        trailing: Text(
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            '\$${expense.amount.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildPeriodContainerExpenses(
                    'Days', const Color(0xFF6D31ED), Colors.white),
                const SizedBox(
                  width: 8,
                ),
                buildPeriodContainerExpenses(
                    'Weekly', const Color(0xFFF5F1FE), const Color(0xFF6D31ED)),
                const SizedBox(
                  width: 8,
                ),
                buildPeriodContainerExpenses('Monthly', const Color(0xFFF5F1FE),
                    const Color(0xFF6D31ED)),
                const SizedBox(
                  width: 8,
                ),
                buildPeriodContainerExpenses(
                    'Year', const Color(0xFFF5F1FE), const Color(0xFF6D31ED)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Income'),
                    Text(
                      '\$${totalIncome.toStringAsFixed(2)}', // Використовуємо totalIncome
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: const Color(0xFF6D31ED)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Outcome'),
                    Text(
                      '\$${totalOutcome.toStringAsFixed(2)}', // Використовуємо totalOutcome
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: const Color.fromARGB(255, 237, 49, 49),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text('Total'),
                    Text(
                      '\$${total.toStringAsFixed(2)}', // Використовуємо total
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: mainContent,
          ),
          const Text('Show more'),
        ],
      ),
      bottomNavigationBar: BottomNavigation(onAddExpense: _addExpense),
    );
  }
}
