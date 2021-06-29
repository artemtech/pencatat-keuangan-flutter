import 'package:hive/hive.dart';
import 'package:pencatat_keuangan/models/report.dart';
import 'package:pencatat_keuangan/services/storage.dart';

class ReportManager {
  Storage? reportStorage;
  static late final ReportManager _instance = ReportManager._internal();

  ReportManager._internal();

  static ReportManager getInstance(Storage _transactionStorage) {
    if (_instance.reportStorage == null) {
      _instance.reportStorage = _transactionStorage;
    }
    return _instance;
  }

  void saveReport(Report report) async {
    reportStorage!.saveData(report);
  }

  void updateReport(key, Report report) {
    reportStorage!.updateData(key, report);
  }

  Future<Map<dynamic, Report>> loadAllReports() async {
    return await reportStorage!.loadData();
  }

  Future<Map<dynamic, Report>> getAt(String month, int year) async {
    var _allReports = await loadAllReports();
    if (_allReports.isEmpty) {
      return {};
    }
    Map<dynamic, Report> result = {};
    for (dynamic item in _allReports.keys) {
      if (_allReports[item]!.bulan == month &&
          _allReports[item]!.tahun == year) {
        Report _r = _allReports[item]!;
        result[item] = _r;
        break;
      }
    }
    return result;
  }
}

class ReportLocalStorage implements Storage {
  Future<Box<dynamic>> transactionsBox = Hive.openBox("reports");

  static final ReportLocalStorage _instance = ReportLocalStorage._internal();

  ReportLocalStorage._internal();

  factory ReportLocalStorage() => _instance;

  @override
  void saveData(transaction) async {
    transactionsBox.then((box) {
      box.add(transaction);
    });
  }

  void deleteData(Report transaction) async {
    transactionsBox.then((box) {
      box.delete(transaction);
    });
  }

  @override
  void updateData(index, newdata) {
    transactionsBox.then((box) {
      box.put(index, newdata);
    });
  }

  @override
  Future<Map<dynamic, Report>> loadData() async {
    Map<dynamic, Report> result = {};
    Box<dynamic> box = await transactionsBox;
    box.toMap().forEach((key, value) {
      Report t = value;
      result[key] = t;
    });
    return result;
  }
}
