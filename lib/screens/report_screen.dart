import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pencatat_keuangan/components/appbar.dart';
import 'package:pencatat_keuangan/config/constant.dart';
import 'package:pencatat_keuangan/models/report.dart';
import 'package:pencatat_keuangan/models/transaction.dart';
import 'package:pencatat_keuangan/screens/detail_report_screen.dart';
import 'package:pencatat_keuangan/services/reports_manager.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  AppBar thisAppBar = appBar("Rekap Bulanan");
  ReportLocalStorage s = ReportLocalStorage();
  late ReportManager r;

  String _selectedReport = "";

  @override
  initState() {
    super.initState();
    r = ReportManager.getInstance(s);
    setInitialSelectedRange();
  }

  void setInitialSelectedRange() {
    _selectedReport = DateFormat("MMMM y", "id_ID").format(DateTime.now());
    print(_selectedReport);
  }

  Future<List<String>> getMonthList() async {
    var reports = await r.loadAllReports();
    if (reports.isEmpty) {
      return [];
    }
    List<String> res = [];
    reports.values.forEach((element) {
      String curDtime = "${element.bulan} ${element.tahun}";
      if (res.indexOf(curDtime) < 0) {
        res.add(curDtime);
      }
    });
    return res;
  }

  Future<List<Report>> getReports() async {
    var reports = await r.loadAllReports();
    if (reports.isEmpty) {
      return [];
    }
    List<Report> res = [];
    reports.values.forEach((element) {
      res.add(element);
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: thisAppBar,
      drawer: navDrawer,
      body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [buildReportRange(), reportStats(_selectedReport)],
          )),
    );
  }

  Widget buildReportRange() {
    return FutureBuilder<List<String>>(
        future: getMonthList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return DropdownButton<String>(
                  value: _selectedReport,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedReport = newValue;
                      });
                    }
                  },
                  items: snapshot.data!.map((String e) {
                    return DropdownMenuItem<String>(value: e, child: Text(e));
                  }).toList());
            }
          }
          return Container();
        });
  }

  Widget reportStats(String timeRange) {
    return FutureBuilder<List<Report>>(
        future: getReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              int totalPengeluaran = 0;
              int totalPemasukan = 0;
              for (Report element in snapshot.data!) {
                String curElementDate = "${element.bulan} ${element.tahun}";
                if (curElementDate == timeRange) {
                  totalPengeluaran = element.pengeluaran;
                  totalPemasukan = element.pemasukan;
                  break;
                }
              }
              if (totalPengeluaran == 0 && totalPemasukan == 0) {
                return Container(
                  child: Text("belum ada catatan transaksi..."),
                );
              }
              return Column(
                children: [
                  // penghasilan & pengeluaran
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailReportScreen(
                                waktu: timeRange,
                                tipe: TransactionType.Pemasukan,
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 15, right: 15),
                      height: 80,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: primarySolid)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.green),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pemasukan"),
                                Text(
                                    "Rp${NumberFormat('#,###', 'id_ID').format(totalPemasukan)}")
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text("Detail"),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailReportScreen(
                                waktu: timeRange,
                                tipe: TransactionType.Pengeluaran,
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 15, right: 15),
                      height: 80,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: primarySolid)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Pengeluaran"),
                                Text(
                                    "Rp${NumberFormat('#,###', 'id_ID').format(totalPengeluaran)}")
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text("Detail"),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return Container(
            child: Text("belum ada catatan transaksi..."),
          );
        });
  }
}
