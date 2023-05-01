import 'package:flutter/material.dart';
import 'package:toward_purpose/dataStorage.dart';
import 'dataModel.dart';

class DataProvider extends ChangeNotifier {
  final DataStorage _dataStorage = DataStorage();
  late dataModel data;

  Future<void> loadData() async {
    data = await _dataStorage.readData();
    notifyListeners();
  }

  Future<void> saveData() async {
    await _dataStorage.writeData(data);
  }

  void clearData() {
    data = dataModel();
    notifyListeners();
  }
}
