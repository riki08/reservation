// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:reservation_app/models/court_model.dart';
import 'package:reservation_app/models/reservation_model.dart';
import 'package:http/http.dart' as http;

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  TextEditingController namePlayerController = TextEditingController();
  String date = '';
  List<DropdownMenuItem<int>> menuItems = [];
  TextEditingController idCourt = TextEditingController();
  String tmp = '';

  HomeBloc() : super(HomeState()) {
    on<GetReservations>(_onGetReservations);
    on<CreateReservation>(_onCreateReservation);
    on<DeleteReservation>(_onDeleteReservation);
  }

  Future<void> _onGetReservations(
      GetReservations event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    List<ReservationModel> reservations = [];
    var boxReservations = await Hive.openBox<ReservationModel>('reservations');

    final instance = boxReservations.values;
    for (ReservationModel reservation in instance) {
      reservations.add(reservation);
    }

    emit(
        state.copyWith(status: HomeStatus.success, reservations: reservations));
  }

  Future<void> _onDeleteReservation(
      DeleteReservation event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    List<ReservationModel> reservations = [];
    var boxReservations = await Hive.openBox<ReservationModel>('reservations');

    int indexAEliminar = 0;
    for (final objeto in boxReservations.values) {
      if (objeto == event.reservationModel) {
        break;
      }
      indexAEliminar++;
    }
    boxReservations.deleteAt(indexAEliminar);

    reservations = [];
    final instance = boxReservations.values;
    for (ReservationModel reservation in instance) {
      reservations.add(reservation);
    }

    emit(
        state.copyWith(status: HomeStatus.success, reservations: reservations));
  }

  Future<void> _onCreateReservation(
      CreateReservation event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    String id = idCourt.text;
    ReservationModel reservation =
        ReservationModel(namePlayerController.text, date, tmp, int.parse(id));

    var boxReservations = await Hive.openBox<ReservationModel>('reservations');

    boxReservations.add(reservation);

    namePlayerController.text = '';
    date = '';
    idCourt.text = '';

    List<ReservationModel> reservations = [];

    final instance = boxReservations.values;
    for (ReservationModel reservation in instance) {
      reservations.add(reservation);
    }

    emit(
        state.copyWith(status: HomeStatus.success, reservations: reservations));
  }

  void createCourt() async {
    var boxCourt = await Hive.openBox<CourtModel>('courts');
    if (boxCourt.isEmpty) {
      final court1 = CourtModel('Cancha A', 'Medellin');
      final court2 = CourtModel('Cancha B', 'Bogota');
      final court3 = CourtModel('Cancha C', 'Cali');

      await boxCourt.add(court1);
      await boxCourt.add(court2);
      await boxCourt.add(court3);
    }
    getCourt();
  }

  void getCourt() async {
    emit(state.copyWith(status: HomeStatus.loading));
    var boxCourt = await Hive.openBox<CourtModel>('courts');
    menuItems = [];

    for (var i = 0; i < boxCourt.length; i++) {
      menuItems.add(DropdownMenuItem(
          value: boxCourt.keyAt(i), child: Text(boxCourt.getAt(i)!.name)));
    }
    emit(state.copyWith(status: HomeStatus.success));
  }

  void getTemp(date) async {
    emit(state.copyWith(status: HomeStatus.loading));
    const apiKey = "a090b9e68527186df4ebb8baaf4602a3";

    const city = "Medellin";

    final url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&dt=$date");
    final response = await http.get(url);

    final data = jsonDecode(response.body);

    final temperature = (data["main"]["temp"] - 273.15).toStringAsFixed(2);
    tmp = temperature;

    emit(state.copyWith(status: HomeStatus.success));
  }
}
