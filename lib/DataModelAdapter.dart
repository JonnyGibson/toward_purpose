import 'package:hive/hive.dart';

import 'dataModel.dart';

class DataModelAdapter extends TypeAdapter<dataModel> {
  @override
  final int typeId = 0;

  @override
  dataModel read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = List<Object?>.filled(numFields, null);
    for (var i = 0; i < numFields; i++) {
      fields[i] = reader.read();
    }

    return dataModel(
      goalStatement: fields[0] as String?,
      measurables: (fields[1] as List<dynamic>?)
          ?.map((e) => Measurable.fromJson(e as Map<String, dynamic>))
          .toList(),
      days: (fields[2] as List<dynamic>?)
          ?.map((e) => Day.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, dataModel obj) {
    writer.writeByte(3);
    writer.write(obj.goalStatement);
    writer.write(obj.measurables);
    writer.write(obj.days);
  }
}
