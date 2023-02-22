import 'package:reservation_app/models/reservation_model.dart';

abstract class HomeRepositoryIml {
  Future<String> getTemperature(String date);
  Future<bool> createReservation(ReservationModel reservation);
}
