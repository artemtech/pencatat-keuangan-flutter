// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportAdapter extends TypeAdapter<Report> {
  @override
  final int typeId = 3;

  @override
  Report read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Report(
      bulan: fields[2] as String,
      tahun: fields[3] as int,
      pemasukan: fields[0] as int,
      pengeluaran: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Report obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.pemasukan)
      ..writeByte(1)
      ..write(obj.pengeluaran)
      ..writeByte(2)
      ..write(obj.bulan)
      ..writeByte(3)
      ..write(obj.tahun);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
