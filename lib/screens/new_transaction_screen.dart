import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pencatat_keuangan/components/appbar.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/models/transaction.dart';
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

  void onBtnSubmitPressed() {
    if (_formKey.currentState!.validate()) {
      // process data
      _formKey.currentState!.save();
      Transaction transaction = new Transaction(
          name: _name,
          description: _catatan,
          price: _price,
          qty: _qty,
          type: _type,
          time: DateTime.now());
      TransactionLocalStorage storage = TransactionLocalStorage();
      TransactionManager transactionManager =
          TransactionManager.getInstance(storage);
      transactionManager.saveTransaction(transaction);
      Navigator.pop(context);
    } else {
      print("invalid!");
    }
  }
}
