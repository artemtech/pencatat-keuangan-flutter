import 'package:hive/hive.dart';
import 'package:pencatat_keuangan/models/transaction.dart';

class TransactionManager {
  ITransactionStorage? transactionStorage;
  static late final TransactionManager _instance =
      TransactionManager._internal();

  TransactionManager._internal();

  static TransactionManager getInstance(
      ITransactionStorage _transactionStorage) {
    if (_instance.transactionStorage == null) {
      _instance.transactionStorage = _transactionStorage;
    }
    return _instance;
  }

  void saveTransaction(Transaction transaction) {
    transactionStorage!.saveData(transaction);
  }
}

abstract class ITransactionStorage {
  void saveData(Transaction transaction);
  List<Transaction> loadData();
}

class TransactionLocalStorage implements ITransactionStorage {
  Box<dynamic> transactionsBox = Hive.box("transactions");

  static final TransactionLocalStorage _instance =
      TransactionLocalStorage._internal();

  TransactionLocalStorage._internal();

  factory TransactionLocalStorage() => _instance;

  @override
  void saveData(Transaction transaction) async {
    transactionsBox.add(transaction);
  }

  void deleteData(Transaction transaction) async {
    transactionsBox.delete(transaction);
  }

  @override
  List<Transaction> loadData() => [];
}
