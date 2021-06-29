import 'package:hive/hive.dart';
part 'report.g.dart';

@HiveType(typeId: 3)
class Report {
  @HiveField(0)
  final int pemasukan;
  @HiveField(1)
  final int pengeluaran;
  @HiveField(2)
  final String bulan;
  @HiveField(3)
  final int tahun;

  Report(
      {required this.bulan,
      required this.tahun,
      required this.pemasukan,
      required this.pengeluaran});
}
