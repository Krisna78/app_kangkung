import 'package:app_kangkung/controller/financial_controller.dart';
import 'package:app_kangkung/home/component/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'detail_transaction.dart';

class FinancialPage extends StatefulWidget {
  FinancialPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final FinancialController financialController =
      Get.put(FinancialController());

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage> {
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;

  final List<String> _days =
      List.generate(31, (index) => (index + 1).toString());
  final List<String> _months =
      List.generate(12, (index) => (index + 1).toString());
  final List<String> _years =
      List.generate(200, (index) => (2000 + index).toString());

  void _onDayChanged(String? selectedValue) {
    setState(() {
      _selectedDay = selectedValue;
    });
  }

  void _onMonthChanged(String? selectedValue) {
    setState(() {
      _selectedMonth = selectedValue;
    });
  }

  void _onYearChanged(String? selectedValue) {
    setState(() {
      _selectedYear = selectedValue;
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              final currency = widget.financialController.netTotal.value;
              return Column(
                children: [
                  Text(
                    "Laba Bersih",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    formatCurrency(currency),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: currency < 0 ? Colors.red : Colors.black),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Obx(() {
              final currency = widget.financialController.totalIncome.value;
              return Column(
                children: [
                  Text(
                    "Laba Kotor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    formatCurrency(currency),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: currency < 0 ? Colors.red : Colors.black),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: widget._formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(158, 158, 158, 0.675),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Hari"),
                              value: _selectedDay,
                              menuMaxHeight: 200,
                              iconEnabledColor: Color(0xFF80AF81),
                              items: _days.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _onDayChanged,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(158, 158, 158, 0.675),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Bulan"),
                              value: _selectedMonth,
                              menuMaxHeight: 200,
                              iconEnabledColor: Color(0xFF80AF81),
                              items: _months.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _onMonthChanged,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(158, 158, 158, 0.675),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: DropdownButton<String>(
                              hint: Text("Tahun"),
                              value: _selectedYear,
                              menuMaxHeight: 200,
                              iconEnabledColor: Color(0xFF80AF81),
                              items: _years.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: _onYearChanged,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MyButton(
              onTap: () {
                int? day =
                    _selectedDay != null ? int.parse(_selectedDay!) : null;
                int? month =
                    _selectedMonth != null ? int.parse(_selectedMonth!) : null;
                int? year =
                    _selectedYear != null ? int.parse(_selectedYear!) : null;
                widget.financialController.fetchTotalsForYear(year, month, day);
                widget.financialController.fetchFinancial(year, month, day);
              },
              nameBtn: "Cari",
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Obx(() {
                  final incomes =
                      widget.financialController.financialTransaction;
                  if (incomes.isEmpty) {
                    return const Center(child: Text("Tidak Ada Data"));
                  } else if (!incomes.isEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: incomes.length,
                      itemBuilder: (context, index) {
                        final income = incomes[index];
                        Color arrowColor = income.type == 'income'
                            ? const Color(0xFF508D4E)
                            : Colors.red;
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => DetailTransaction(id: income.id!));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6EFD8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          formatCurrency(income.amount),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
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
                                      formattedDate(income.periodeTanggal!),
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
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Tidak ada data"));
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
