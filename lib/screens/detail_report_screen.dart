import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pencatat_keuangan/components/appbar.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/models/transaction.dart';
import 'package:pencatat_keuangan/services/transaction_manager.dart';

class DetailReportScreen extends StatelessWidget {
  final String waktu;
  final TransactionType tipe;
  final TransactionLocalStorage _tstorage = TransactionLocalStorage();

  DetailReportScreen({Key? key, required this.waktu, required this.tipe})
      : super(key: key);

  Future<List<Transaction>> listTransaction() async {
    TransactionManager _tm = TransactionManager.getInstance(_tstorage);
    var c = _tm.loadAllTransactions();
    if (c.isEmpty) {
      return [];
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    AppBar thisAppBar = appBar(tipe == TransactionType.Pemasukan
        ? "Rincian Pemasukan"
        : "Rincian Pengeluaran");
    return Scaffold(
      appBar: thisAppBar,
      body: FutureBuilder<List<Transaction>>(
          future: listTransaction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data!.length > 0) {
              List<Transaction> _list = [];
              int grandTotal = 0;
              snapshot.data!.forEach((element) {
                if (DateFormat("MMMM y", 'id_ID').format(element.time) ==
                        waktu &&
                    element.type == tipe) {
                  _list.add(element);
                  grandTotal += (element.price * element.qty).toInt();
                }
              });
              if (grandTotal == 0) {
                return Center(child: Text("Tidak ada transaksi"));
              }
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    color: primarySolid.withOpacity(0.6),
                    child: Center(
                        child: Text(
                      "${NumberFormat('Rp#,###', 'id_ID').format(grandTotal)}",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: whiteTextColor),
                    )),
                  ),
                  Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        itemCount: _list.length,
                        separatorBuilder: (context, index) => Divider(
                              thickness: 1,
                            ),
                        itemBuilder: (context, index) {
                          return ListTile(
                            minVerticalPadding: 0,
                            leading: Text(
                                (DateFormat("dd\nMMMM\ny\nHH:mm", 'id_ID')
                                    .format(_list[index].time))),
                            title: Text(_list[index].name),
                            subtitle: Text(_list[index].description),
                            trailing: Text(
                                "${NumberFormat('Rp#,###', 'id_ID').format((_list[index].price * _list[index].qty).toInt())}"),
                          );
                        }),
                  ),
                ],
              );
            }
            return Center(child: Text("Tidak ada transaksi"));
          }),
    );
  }
}
