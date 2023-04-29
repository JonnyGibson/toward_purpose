import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'DataModelAdapter.dart';
import 'dataModel.dart';

class HiveManager {
  static late final Box<dataModel> dataBox;

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter<dataModel>(DataModelAdapter());
    dataBox = await Hive.openBox<dataModel>('dataBox');
  }
}
