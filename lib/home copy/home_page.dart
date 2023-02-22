import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/home/bloc/home_bloc.dart';
import 'package:reservation_app/models/reservation_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.createCourt();
    homeBloc.add(GetReservations());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de reservaciones'),
        actions: [
          GestureDetector(
              onTap: () {
                homeBloc.add(CreateReservation());
              },
              child: Container(
                margin: const EdgeInsets.only(right: 5, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(0, 0),
                          blurRadius: 1)
                    ]),
                child: const Text(
                  'Crear reserva',
                  style: TextStyle(color: Colors.black),
                ),
              ))
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const CircularProgressIndicator();
          }
          return Container(
            child: state.reservations!.isEmpty
                ? const Center(
                    child: Text(
                    'En este momento no hay reservaciones realizadas',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ))
                : ListView.builder(
                    itemCount: state.reservations!.length,
                    itemBuilder: (context, index) {
                      ReservationModel reservation = state.reservations![index];
                      return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Nombre de la cancha: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(reservation.playerName),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Fecha de reserva: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(reservation.date),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Responsable: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(reservation.playerName),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Pronostico del tiempo: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text('${reservation.forecast} Grados'),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    },
                  ),
          );
        },
      ),
    );
  }
}
