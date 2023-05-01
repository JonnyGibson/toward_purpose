import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:toward_purpose/dataModel.dart';
import 'dart:io';

class DataStorage {
  final String fileName = 'data.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<dataModel> readData() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      final jsonMap = jsonDecode(contents);
      return dataModel.fromJson(jsonMap);
    } catch (e) {
      // If encountering an error, return null
      return dataModel();
    }
  }

  Future<File> writeData(dataModel data) async {
    final file = await _localFile;

    // Convert data to JSON and write it to the file
    final jsonMap = data.toJson();
    final jsonStr = jsonEncode(jsonMap);
    return file.writeAsString(jsonStr);
  }
}
