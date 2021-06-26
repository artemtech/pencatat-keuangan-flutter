import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  String name;
  @HiveField(1)
  double qty;
  @HiveField(2)
  int price;
  @HiveField(3)
  String description;
  @HiveField(4)
  TransactionType type;
  @HiveField(5)
  DateTime time;

  Transaction(
      {required this.name,
      required this.description,
      required this.price,
      required this.qty,
      required this.type,
      required this.time});
}

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  Pemasukan,
  @HiveField(1)
  Pengeluaran
}
