// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_finance/helper/balance_detail.dart';
import 'package:my_finance/helper/dialog.dart';
import 'package:my_finance/model/balance_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  TextEditingController _moneyController = TextEditingController();
  // final Currency _currencyFormatter = Currency();

  TextEditingController _textController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
  }

  void showError(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(errorMessage: errorMessage);
      },
    );
  }

  void showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SuccessDialog(
            message: 'Selamat, Anda berhasil memasukkan income.');
      },
    );
  }

  clearAll() {
    setState(() {
      _dateController = TextEditingController();
      _textController = TextEditingController();
      _moneyController = TextEditingController();
    });
  }

  createIncome() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final date = _dateController.text;
      final desc = _textController.text;
      final nominal = _moneyController.text;
      if (date.isEmpty || desc.isEmpty || nominal.isEmpty) {
        return showError(context, "harap isi semuanya");
      }

      int idBalance = prefs.getInt('idBalance') ?? 0;

      final balanceDetail = BalanceDetail(
          idBalance: idBalance,
          type: "in",
          nominal: double.parse(nominal),
          desc: desc,
          date: date);
      await addBalanceDetail(balanceDetail);

      clearAll();
      // ignore: use_build_context_synchronously
      return showSuccess(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Income"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                  ),
                ),
                onTap: () {
                  _selectDate(context);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _moneyController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  prefixText: 'Rp ',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Information',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    onPrimary: Colors.white, // Background color
                  ),
                  onPressed: () {
                    clearAll();
                  },
                  child: Text('Reset'),
                ),
                SizedBox(width: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white, // Background color
                  ),
                  onPressed: () {
                    createIncome();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
