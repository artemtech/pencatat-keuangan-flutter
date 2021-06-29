import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pencatat_keuangan/components/appbar.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/models/report.dart';
import 'package:pencatat_keuangan/models/transaction.dart';
import 'package:pencatat_keuangan/services/reports_manager.dart';
import 'package:pencatat_keuangan/services/transaction_manager.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({Key? key}) : super(key: key);

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  TextEditingController priceController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late int _price;
  late double _qty;
  late String _catatan;
  TransactionType _type = TransactionType.Pemasukan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Tambah transaksi baru"),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: CustomScrollView(
          shrinkWrap: false,
          slivers: [
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(children: [
                  TextFormField(
                    key: Key("nama"),
                    onSaved: (String? value) {
                      _name = value ?? '';
                    },
                    validator: (String? value) {
                      if (value == null ||
                          value.length < 1 ||
                          value.trim() == '') {
                        return 'Mohon untuk diisi!';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Nama transaksi",
                        hintText: "contoh: Beli sabun"),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    key: Key("qty"),
                    onSaved: (String? value) {
                      _qty = double.tryParse(value!) ?? 0;
                    },
                    validator: (String? value) {
                      if (value == null ||
                          value.length < 1 ||
                          value.trim() == '' ||
                          double.parse(value) < 0) {
                        return 'Mohon untuk diisi!';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Qty", hintText: "contoh: 5"),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                  ),
                  DropdownButtonFormField<TransactionType>(
                      key: Key("type"),
                      onSaved: (TransactionType? value) {
                        if (value != null) {
                          _type = value;
                        }
                      },
                      value: _type,
                      onChanged: (TransactionType? value) {
                        if (value != null) {
                          setState(() {
                            _type = value;
                          });
                        }
                      },
                      items: [
                        DropdownMenuItem(
                            value: TransactionType.Pemasukan,
                            child: Text(TransactionType.Pemasukan.toString()
                                .replaceAll('TransactionType.', ''))),
                        DropdownMenuItem(
                            value: TransactionType.Pengeluaran,
                            child: Text(TransactionType.Pengeluaran.toString()
                                .replaceAll('TransactionType.', '')))
                      ]),
                  TextFormField(
                    key: Key("price"),
                    onSaved: (String? value) {
                      _price = int.tryParse(value!.replaceAll(',', '')) ?? 0;
                    },
                    decoration: InputDecoration(
                        labelText: "Harga satuan",
                        hintText: "contoh: 5000",
                        prefix: Text("Rp")),
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    validator: (value) {
                      if (value == null ||
                          value.length < 1 ||
                          value.trim() == '') {
                        return 'Mohon untuk diisi!';
                      }
                    },
                    onChanged: (newValue) {
                      if (newValue.length > 0) {
                        var price = int.parse(newValue.replaceAll(',', ''));
                        var comma = NumberFormat('###,###');
                        var newString = comma.format(price);
                        int selectionIndex = newValue.length -
                            priceController.selection.extentOffset;
                        priceController.text = newString;
                        priceController.selection = TextSelection.collapsed(
                            offset: newString.length - selectionIndex);
                      }
                    },
                  ),
                  TextFormField(
                    key: Key("catatan"),
                    onSaved: (String? value) {
                      _catatan = value ?? '';
                    },
                    decoration: InputDecoration(
                        labelText: "Catatan",
                        hintText:
                            "contoh: Beli di warungnya si Fulan buat mandi"),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ]),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: onBtnSubmitPressed,
                      style: ElevatedButton.styleFrom(
                        primary: primarySolid,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width, 40),
                      ),
                      child: Text("Tambahkan"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onBtnSubmitPressed() async {
    if (_formKey.currentState!.validate()) {
      // process data
      _formKey.currentState!.save();
      DateTime curTime = DateTime.now();
      Transaction transaction = new Transaction(
          name: _name,
          description: _catatan,
          price: _price,
          qty: _qty,
          type: _type,
          time: curTime);
      TransactionLocalStorage trxStorage = TransactionLocalStorage();
      TransactionManager transactionManager =
          TransactionManager.getInstance(trxStorage);
      transactionManager.saveTransaction(transaction);

      ReportLocalStorage reportStorage = ReportLocalStorage();
      ReportManager reportManager = ReportManager.getInstance(reportStorage);
      String month = DateFormat.MMMM("id_ID").format(curTime);
      int year = int.parse(DateFormat.y("id_ID").format(curTime));
      Map<dynamic, Report> _oldReport = await reportManager.getAt(month, year);
      if (_oldReport.isEmpty) {
        Report _newReport = Report(
            pemasukan: (_type == TransactionType.Pemasukan)
                ? (_price * _qty).toInt()
                : 0,
            pengeluaran: (_type == TransactionType.Pengeluaran)
                ? (_price * _qty).toInt()
                : 0,
            bulan: month,
            tahun: year);
        reportManager.saveReport(_newReport);
      } else {
        Report _newReport = Report(
            pemasukan: (_type == TransactionType.Pemasukan)
                ? _oldReport.values.first.pemasukan + (_price * _qty).toInt()
                : _oldReport.values.first.pemasukan,
            pengeluaran: (_type == TransactionType.Pengeluaran)
                ? _oldReport.values.first.pengeluaran + (_price * _qty).toInt()
                : _oldReport.values.first.pengeluaran,
            bulan: month,
            tahun: year);
        reportManager.updateReport(_oldReport.keys.first, _newReport);
      }
      Navigator.pop(context);
    } else {
      print("invalid!");
    }
  }
}
