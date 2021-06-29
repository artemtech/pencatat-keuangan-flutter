import 'package:hive/hive.dart';
import 'package:pencatat_keuangan/models/transaction.dart';
import 'package:pencatat_keuangan/services/storage.dart';

class TransactionManager {
  Storage? transactionStorage;
  static late final TransactionManager _instance =
      TransactionManager._internal();

  TransactionManager._internal();

  static TransactionManager getInstance(Storage _transactionStorage) {
    if (_instance.transactionStorage == null) {
      _instance.transactionStorage = _transactionStorage;
    }
    return _instance;
  }

  void saveTransaction(Transaction transaction) {
    transactionStorage!.saveData(transaction);
  }

  List<Transaction> loadAllTransactions() {
    return transactionStorage!.loadData();
  }
}

class TransactionLocalStorage implements Storage {
  Box<dynamic> transactionsBox = Hive.box("transactions");

  static final TransactionLocalStorage _instance =
      TransactionLocalStorage._internal();

  TransactionLocalStorage._internal();

  factory TransactionLocalStorage() => _instance;

  @override
  void saveData(transaction) async {
    transactionsBox.add(transaction);
  }

  void deleteData(Transaction transaction) async {
    transactionsBox.delete(transaction);
  }

  @override
  List<Transaction> loadData() {
    List<Transaction> result = [];
    transactionsBox.toMap().forEach((key, value) {
      Transaction t = value;
      result.add(t);
    });
    return result;
  }

  @override
  void updateData(index, newData) {
    // TODO: implement updateData
  }
}
