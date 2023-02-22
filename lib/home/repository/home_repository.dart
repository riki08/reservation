import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:reservation_app/home/data/home_repository_iml.dart';
import 'package:http/http.dart' as http;
import 'package:reservation_app/models/reservation_model.dart';

class HomeRepository extends HomeRepositoryIml {
  @override
  Future<String> getTemperature(String date) async {
    // Clave API de OpenWeatherMap
    const apiKey = "a090b9e68527186df4ebb8baaf4602a3";

    // Ciudad y fecha para obtener el clima
    const city = "Medellin"; // o "Bogota"
    date = "2023-02-24"; // fecha actual

    // Realizar solicitud HTTP a la API de OpenWeatherMap
    final url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&dt=$date");
    final response = await http.get(url);

    // Convertir la respuesta a formato JSON
    final data = jsonDecode(response.body);

    // Obtener la temperatura en grados Celsius
    final temperature = (data["main"]["temp"] - 273.15).toStringAsFixed(2);

    return temperature;
  }

  @override
  Future<bool> createReservation(ReservationModel reservation) async {
    var boxReservations = await Hive.openBox<ReservationModel>('reservations');

    boxReservations.put(reservation.playerName, reservation);

    return true;
  }
}
