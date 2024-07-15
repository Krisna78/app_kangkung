import 'package:app_kangkung/home/detail_transaction.dart';
import 'package:app_kangkung/home/expense/expense_page.dart';
import 'package:app_kangkung/home/income/income_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/income_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final IncomeController incomeController = Get.put(IncomeController());
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int totalIncome = 0;
  void loadTotalIncome() async {
    final total = await widget.incomeController.calculateTotalIncomeThisMonth();
    widget.incomeController.totalIncome.value = total;
  }

  String formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String formattedDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }

  @override
  void initState() {
    super.initState();
    loadTotalIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Pendapatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  Obx(
                    () {
                      final netIncome =
                          widget.incomeController.totalIncome.value;
                      return Text(
                        formatCurrency(netIncome),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: netIncome < 0 ? Colors.red : Colors.black),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => IncomePage());
                        },
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            Color(0xFF80AF81),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.only(
                                top: 12, bottom: 12, left: 25, right: 25),
                          ),
                        ),
                        child: const Text(
                          "Pendapatan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => ExpensePage());
                        },
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            Color(0xFF80AF81),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          padding: const WidgetStatePropertyAll<EdgeInsets>(
                            EdgeInsets.only(
                                top: 12, bottom: 12, left: 25, right: 25),
                          ),
                        ),
                        child: const Text(
                          "Pengeluaran",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Data Hari Ini",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Obx(() {
                        final incomes = widget.incomeController.todayIncomes;
                        if (incomes.isEmpty) {
                          return const Center(child: Text("Belum Ada Data"));
                        } else if (!incomes.isEmpty) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: incomes.length,
                            itemBuilder: (context, index) {
                              final income = incomes[index];
                              Color arrowColor = income.type == 'income'
                                  ? const Color(0xFF508D4E)
                                  : Colors.red;
                              return Dismissible(
                                key: Key(income.id.toString()),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) async {
                                  await widget.incomeController.deleteIncome(
                                      income.id!); // Call delete function
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${income.title} Terhapus',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      backgroundColor: Color(0xFF508D4E),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() =>
                                        DetailTransaction(id: income.id!));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD6EFD8),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                income.type == 'income'
                                                    ? Icons
                                                        .keyboard_double_arrow_up_outlined
                                                    : Icons
                                                        .keyboard_double_arrow_down_outlined,
                                                size: 40,
                                                color: arrowColor,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  income.title,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  formatCurrency(
                                                      income.amount),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_month_outlined),
                                            const SizedBox(width: 3),
                                            Text(
                                              formattedDate(
                                                  income.periodeTanggal!),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text("Belum Ada Data"));
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
