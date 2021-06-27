import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:pencatat_keuangan/components/appbar.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/models/transaction.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Transaksi Hari ini"),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: primarySolid,
        onPressed: () {
          Navigator.pushNamed(context, addNewTransactionPage).then((value) {
            setState(() {});
          });
        },
      ),
      body: FutureBuilder(
        future: Hive.openBox('transactions'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error as String));
            }
            if (snapshot.hasData) {
              var transactionBox = Hive.box("transactions");
              if (transactionBox.length < 1) {
                return buildEmptyTransaction();
              }
              return buildTransactionsList(transactionBox);
            }
            return buildEmptyTransaction();
          }
        },
      ),
    );
  }

  Widget buildTransactionsList(Box<dynamic> transactionsBox) {
    return ValueListenableBuilder(
        valueListenable: transactionsBox.listenable(),
        builder:
            (BuildContext context, Box<dynamic> _transactions, Widget? child) {
          print("ini dari luarnya: ${transactionsBox.length}");
          print("ini dari dalemnya: ${_transactions.length}");
          if (transactionsBox.length == 0) {
            return buildEmptyTransaction();
          }
          int totalPemasukan = 0;
          int totalPengeluaran = 0;
          transactionsBox.toMap().forEach((key, value) {
            Transaction t = _transactions.get(key);
            if (t.type == TransactionType.Pemasukan) {
              totalPemasukan += (t.price * t.qty).toInt();
            } else {
              totalPengeluaran += (t.price * t.qty).toInt();
            }
          });
          int totalHariIni = totalPemasukan - totalPengeluaran;

          return CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _transactions.length,
                      itemBuilder: (ctx, index) {
                        Transaction transaction = _transactions.getAt(index);
                        return SizedBox(
                          height: 80,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (transaction.type ==
                                          TransactionType.Pemasukan)
                                      ? Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.arrow_downward,
                                          color: Colors.red,
                                        ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(transaction.name),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Text(
                                    "Rp${NumberFormat('#,###').format((transaction.price * transaction.qty).toInt())}",
                                    style: TextStyle(
                                        color: (transaction.type ==
                                                TransactionType.Pemasukan)
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        _transactions.deleteAt(index);
                                      },
                                      child: Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          top: BorderSide(color: primarySolid))),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Pemasukan hari ini:",
                          style: (totalHariIni < 0)
                              ? textStyle(textColor: Colors.red)
                              : textStyle()),
                      Text(
                        "${NumberFormat('Rp#,###').format(totalHariIni)}",
                        style: (totalHariIni < 0)
                            ? textStyle(textColor: Colors.red, isBold: true)
                            : textStyle(isBold: true),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  Center buildEmptyTransaction() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/img/no-data.png",
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Belum ada catatan transaksi\nuntuk hari ini",
            textAlign: TextAlign.center,
            style: textStyle(textColor: primarySolid),
          )
        ],
      ),
    );
  }
}
