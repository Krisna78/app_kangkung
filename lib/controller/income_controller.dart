import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/income.dart';
import 'database_helper.dart';

class IncomeController extends GetxController {
  var incomes = <Income>[].obs;
  var totalIncome = 0.obs;
  var todayIncomes = <Income>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchIncomes();
  }

  Future<void> addIncome(Income income) async {
    await DatabaseHelper.instance.insertIncome(income);
    await fetchIncomes();
  }

  Future<void> addExpense(Income income) async {
    await DatabaseHelper.instance.insertIncome(income);
    await fetchIncomes();
  }

  Future<void> fetchIncomes() async {
    incomes.value = await DatabaseHelper.instance.fetchIncomes();
    await calculateTotalIncomeThisMonth();
    await fetchTodayIncomes();
  }

  Future<void> updateIncome(Income income) async {
    await DatabaseHelper.instance.updateIncome(income);
    await fetchIncomes();
  }

  Future<Income?> getIncomeDetails(int id) async {
    return await DatabaseHelper.instance.fetchIncomeById(id);
  }

  Future<void> deleteIncome(int id) async {
    await DatabaseHelper.instance.deleteIncome(id);
    await fetchIncomes();
  }

  Future<int> calculateTotalIncomeThisMonth() async {
    final db = await DatabaseHelper.instance.database;
    final now = DateTime.now();
    String formattedMonth = DateFormat('yyyy-MM').format(now);
    final result = await db.query(
      'transactions',
      where: 'strftime("%Y-%m", periode_tanggal) = ?',
      whereArgs: [formattedMonth],
    );
    int total_income = 0;
    int total_expense = 0;
    for (var json in result) {
      final transaction = Income.fromMap(json);
      if (transaction.type == 'income') {
        total_income += transaction.amount;
      } else if (transaction.type == 'expense') {
        total_expense += transaction.amount;
      }
    }
    totalIncome.value = total_income - total_expense;
    return totalIncome.value;
  }

  Future<void> fetchTodayIncomes() async {
    final db = await DatabaseHelper.instance.database;
    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);

    final result = await db.query(
      'transactions',
      where: 'periode_tanggal = ?',
      whereArgs: [todayString],
    );
    todayIncomes.value = result.map((json) => Income.fromMap(json)).toList();
  }
}
