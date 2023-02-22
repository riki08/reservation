import 'package:hive/hive.dart';
import 'package:reservation_app/models/court_model.dart';

part 'hive/reservation_model.g.dart';

@HiveType(typeId: 1)
class ReservationModel {
  @HiveField(0)
  String playerName;

  @HiveField(1)
  String date;

  @HiveField(2)
  String forecast;

  @HiveField(3)
  int courtId;

  CourtModel? get court => Hive.box<CourtModel>('courts').get(courtId);

  ReservationModel(this.playerName, this.date, this.forecast, this.courtId);
}
