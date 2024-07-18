import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/income.dart';
import 'database_helper.dart';

class FinancialController {
  var totalIncome = 0.obs;
  var totalExpense = 0.obs;
  var netTotal = 0.obs;
  var financialTransaction = <Income>[].obs;

  Future<Map<String, int>> calculateTotalIncomeAndExpenses({int? year,int? month,int? day}) async {
    final db = await DatabaseHelper.instance.database;

    String whereClause;
    List<String> whereArgs;
    final now = DateTime.now();

    if (day != null) {
        if (month == null) month = now.month;
        if (year == null) year = now.year;
        String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime(year, month, day));
        whereClause = 'strftime("%Y-%m-%d", periode_tanggal) = ?';
        whereArgs = [formattedDate];
    } else if (month != null) {
        if (year == null) year = now.year;
        String formattedMonth = DateFormat('yyyy-MM').format(DateTime(year, month));
        whereClause = 'strftime("%Y-%m", periode_tanggal) = ?';
        whereArgs = [formattedMonth];
    } else if (year != null) {
        String formattedYear = DateFormat('yyyy').format(DateTime(year));
        whereClause = 'strftime("%Y", periode_tanggal) = ?';
        whereArgs = [formattedYear];
    } else {
        // Default to the current month if no date is provided
        String formattedMonth = DateFormat('yyyy-MM').format(now);
        whereClause = 'strftime("%Y-%m", periode_tanggal) = ?';
        whereArgs = [formattedMonth];
    }

    final result = await db.query(
      'transactions',
      where: whereClause,
      whereArgs: whereArgs,
    );

    int total_income = 0;
    int total_expense = 0;
    List<Income> financialList = [];

    for (var json in result) {
      final transaction = Income.fromMap(json);
      financialList.add(transaction);
      if (transaction.type == 'income') {
        total_income += transaction.amount;
      } else if (transaction.type == 'expense') {
        total_expense += transaction.amount;
      }
    }
    financialTransaction.value = financialList;
    return {
      'totalIncome': total_income,
      'totalExpense': total_expense,
      'netTotal': total_income - total_expense,

    };
  }

  Future<void> fetchTotalsForYear(int? year, int? month, int? day) async {
    final totals = await calculateTotalIncomeAndExpenses(year: year, month: month, day: day);
    totalIncome.value = totals['totalIncome'] ?? 0;
    totalExpense.value = totals['totalExpense'] ?? 0;
    netTotal.value = totals['netTotal'] ?? 0;
  }
  Future<void> fetchFinancial(int? year,int? month,int? day) async {
    await calculateTotalIncomeAndExpenses(year: year,month: month,day: day);
  }
}
