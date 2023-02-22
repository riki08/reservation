part of '../reservation_model.dart';

class ReservationAdapter extends TypeAdapter<ReservationModel> {
  @override
  final typeId = 1;

  @override
  ReservationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReservationModel(
        fields[0], fields[1] ?? '', fields[2] ?? '', fields[3] ?? 0);
  }

  @override
  void write(BinaryWriter writer, ReservationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.playerName)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.forecast)
      ..writeByte(3)
      ..write(obj.courtId);
  }
}
