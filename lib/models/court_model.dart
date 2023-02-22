import 'package:hive/hive.dart';

part 'hive/court_model.g.dart';

@HiveType(typeId: 0)
class CourtModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String location;

  CourtModel(this.name, this.location);
}
