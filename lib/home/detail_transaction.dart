import 'package:app_kangkung/home/component/button.dart';
import 'package:app_kangkung/home/component/button_navigation.dart';
import 'package:app_kangkung/home/component/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';

import '../controller/income_controller.dart';
import '../model/income.dart';

class DetailTransaction extends StatefulWidget {
  final int id;
  DetailTransaction({super.key, required this.id});
  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
  final titleControl = TextEditingController();
  final quantityControl = TextEditingController();
  final satuanControl = TextEditingController();
  final deskripsiControl = TextEditingController();
  late String periodeTanggal;
  late String type;
}

class _DetailTransactionState extends State<DetailTransaction> {
  final IncomeController incomeController = Get.put(IncomeController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadIncomeDetails();
  }

  Future<void> _loadIncomeDetails() async {
    Income? income = await incomeController.getIncomeDetails(widget.id);
    if (income != null) {
      widget.titleControl.text = income.title;
      widget.quantityControl.text = income.quantity.toString(); 
      widget.satuanControl.text = income.hargaSatuan.toString();
      widget.deskripsiControl.text = income.deskripsi ?? '';
      widget.periodeTanggal = income.periodeTanggal!;
      widget.type = income.type!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Center(
        child: FutureBuilder<Income?>(
          future: incomeController.getIncomeDetails(widget.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Belum Ada Data'));
            } else {
              // final income = snapshot.data!;
              return Padding(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                        controller: widget.deskripsiControl,
                        hintText: "Deskripsi",
                        isLongText: true,
                        textInputType: TextInputType.multiline,
                        maxLine: 4,
                      ),
                      const SizedBox(height: 12),
                      MyButton(onTap: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          Income? existingIncome = await incomeController.getIncomeDetails(widget.id);
                          final updatedIncome = Income(
                            id:  widget.id,
                            periodeTanggal: widget.periodeTanggal,
                            type: widget.type,
                            title: widget.titleControl.text,
                            quantity: int.parse(widget.quantityControl.text),
                            hargaSatuan: int.parse(widget.satuanControl.text),
                            deskripsi: widget.deskripsiControl.text,
                            amount: int.parse(widget.quantityControl.text) * int.parse(widget.satuanControl.text),
                          );
                          await incomeController.updateIncome(updatedIncome);
                          Get.off(() => ButtonNavigation());
                        }
                      }, nameBtn: "Update"),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
