// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class dataModelAdapter extends TypeAdapter<dataModel> {
  @override
  final int typeId = 0;

  @override
  dataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return dataModel(
      goalStatement: fields[0] as String?,
      measurables: (fields[1] as List?)?.cast<Measurable>(),
      days: (fields[2] as List?)?.cast<Day>(),
    );
  }

  @override
  void write(BinaryWriter writer, dataModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.goalStatement)
      ..writeByte(1)
      ..write(obj.measurables)
      ..writeByte(2)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is dataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeasurableAdapter extends TypeAdapter<Measurable> {
  @override
  final int typeId = 1;

  @override
  Measurable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Measurable(
      name: fields[0] as String?,
      targetWeeklyHours: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Measurable obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.targetWeeklyHours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayAdapter extends TypeAdapter<Day> {
  @override
  final int typeId = 2;

  @override
  Day read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Day(
      date: fields[0] as String?,
      dailyScore: fields[1] as int?,
      qualitativeComment: fields[2] as String?,
      activities: (fields[3] as List?)?.cast<Activity>(),
    );
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.dailyScore)
      ..writeByte(2)
      ..write(obj.qualitativeComment)
      ..writeByte(3)
      ..write(obj.activities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 3;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      name: fields[0] as String?,
      goal: fields[1] as String?,
      hours: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.goal)
      ..writeByte(2)
      ..write(obj.hours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
