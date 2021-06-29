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
  AppBar thisAppBar = appBar("Transaksi Hari ini");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: thisAppBar,
      drawer: navDrawer,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: primarySolid,
        onPressed: () {
          Navigator.pushNamed(context, addNewTransactionPage).then((value) {
            setState(() {});
          });
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: primarySolid.withOpacity(0.5),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now()),
              style: textStyle(textColor: whiteTextColor),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
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
          ),
        ],
      ),
    );
  }

  Widget buildTransactionsList(Box<dynamic> transactionsBox) {
    return ValueListenableBuilder(
        valueListenable: transactionsBox.listenable(),
        builder:
            (BuildContext context, Box<dynamic> _transactions, Widget? child) {
          if (transactionsBox.length == 0) {
            return buildEmptyTransaction();
          }
          int totalPemasukan = 0;
          int totalPengeluaran = 0;
          bool isTodayHaveTransactions = false;
          Map<dynamic, Transaction> _todayTransactions = {};
          transactionsBox.toMap().forEach((key, value) {
            Transaction t = _transactions.get(key);
            if (DateFormat('yyyyMMdd').format(t.time) ==
                DateFormat('yyyyMMdd').format(DateTime.now())) {
              isTodayHaveTransactions = true;
              _todayTransactions[key] = t;
              if (t.type == TransactionType.Pemasukan) {
                totalPemasukan += (t.price * t.qty).toInt();
              } else {
                totalPengeluaran += (t.price * t.qty).toInt();
              }
            }
          });
          if (!isTodayHaveTransactions) {
            return buildEmptyTransaction();
          }
          int totalHariIni = totalPemasukan - totalPengeluaran;

          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height -
                    thisAppBar.preferredSize.height -
                    80 -
                    20 -
                    50,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _todayTransactions.length,
                    itemBuilder: (ctx, index) {
                      Transaction transaction = _transactions
                          .get(_todayTransactions.keys.elementAt(index));
                      return SizedBox(
                        height: 80,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (transaction.type == TransactionType.Pemasukan)
                                    ? Icon(
                                        Icons.arrow_downward,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.arrow_upward,
                                        color: Colors.red,
                                      ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: Text(transaction.name),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  "Rp${NumberFormat('#,###', 'id_ID').format((transaction.price * transaction.qty).toInt())}",
                                  style: TextStyle(
                                      color: (transaction.type ==
                                              TransactionType.Pemasukan)
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _transactions.delete(_todayTransactions
                                          .keys
                                          .elementAt(index));
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: whiteTextColor,
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
                        "${NumberFormat('Rp#,###', 'id_ID').format(totalHariIni)}",
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
