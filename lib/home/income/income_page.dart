import 'package:app_kangkung/controller/income_controller.dart';
import 'package:app_kangkung/home/component/button.dart';
import 'package:app_kangkung/home/component/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../model/income.dart';

class IncomePage extends StatefulWidget {
  IncomePage({super.key});
  final _formKey = GlobalKey<FormState>();
  final titleControl = TextEditingController();
  final dateControl = TextEditingController();
  final quantityControl = TextEditingController();
  final satuanControl = TextEditingController();
  final deskripsiControl = TextEditingController();

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final IncomeController incomeController = Get.find<IncomeController>();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
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

    String formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: widget._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tambah Pendapatan",
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
                  hintText: "Jumlah Ikat",
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
                  controller: widget.dateControl,
                  hintText: "Tanggal",
                  textInputType: TextInputType.datetime,
                  isFilled: true,
                  isDateField: true,
                  prefixIcon: IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_month)),
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
                          type: 'income',
                          quantity: int.parse(widget.quantityControl.text),
                          hargaSatuan: int.parse(widget.satuanControl.text),
                          amount: int.parse(widget.quantityControl.text) *
                              int.parse(widget.satuanControl.text),
                          title: widget.titleControl.text,
                          deskripsi: widget.deskripsiControl.text,
                        );
                        await incomeController.addIncome(income);
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
