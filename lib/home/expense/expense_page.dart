import 'package:app_kangkung/home/component/button.dart';
import 'package:app_kangkung/home/component/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/income_controller.dart';
import '../../model/income.dart';

class ExpensePage extends StatefulWidget {
  ExpensePage({super.key});
  final _formKey = GlobalKey<FormState>();
  final titleControl = TextEditingController();
  final quantityControl = TextEditingController();
  final satuanControl = TextEditingController();
  final deskripsiControl = TextEditingController();
  final dateControl = TextEditingController();

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final IncomeController incomeController = Get.find<IncomeController>();
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: now,
      );
      if (picked != null && picked != now) {
        setState(() {
          now = picked;
          widget.dateControl.text =
              DateFormat('dd-MM-yyyy').format(now);
        });
      }
    }
    String formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: widget._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Tambah Pengeluaran",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.titleControl,
                  hintText: "Judul",
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.quantityControl,
                  hintText: "Jumlah Barang",
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.satuanControl,
                  hintText: "Harga Satuan",
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextFieldPage(
                  controller: widget.deskripsiControl,
                  hintText: "Deskripsi",
                  isLongText: true,
                  maxLine: 5,
                  textInputType: TextInputType.multiline,
                ),
                const SizedBox(height: 12),
                MyButton(
                    onTap: () async {
                      if (widget._formKey.currentState!.validate()) {
                        String dbFormattedDate =
                            widget.dateControl.text.isNotEmpty
                                ? DateFormat('yyyy-MM-dd').format(
                                    DateFormat('dd-MM-yyyy')
                                        .parse(widget.dateControl.text))
                                : formattedDate;
                        final income = Income(
                          periodeTanggal: dbFormattedDate,
                          type: 'expense',
                          quantity: int.parse(widget.quantityControl.text),
                          hargaSatuan: int.parse(widget.satuanControl.text),
                          amount: int.parse(widget.quantityControl.text) *
                              int.parse(widget.satuanControl.text),
                          title: widget.titleControl.text,
                          deskripsi: widget.deskripsiControl.text,
                        );
                        await incomeController.addExpense(income);
                        Navigator.pop(context);
                      }
                    },
                    nameBtn: "Simpan"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
