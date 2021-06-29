abstract class Storage {
  void saveData(var data);
  void updateData(dynamic index, dynamic newData);
  dynamic loadData();
}
