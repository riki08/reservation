part of '../court_model.dart';

class CourtAdapter extends TypeAdapter<CourtModel> {
  @override
  final typeId = 0;

  @override
  CourtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourtModel(fields[0], fields[3] ?? '');
  }

  @override
  void write(BinaryWriter writer, CourtModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.location);
  }
}
