import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_app/home/bloc/home_bloc.dart';
import 'package:reservation_app/home/screens/create_reservation.dart';
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
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => CreateReservationPage(
                            homeBloc: homeBloc,
                          )),
                );
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
            return const Center(child: CircularProgressIndicator());
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Nombre de la cancha: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(reservation.court!.name),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text('Reservado a: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(reservation.playerName),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text('Fecha de reserva: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(reservation.date),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Text('Pronostico del tiempo: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text('${reservation.forecast}°'),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () =>
                                        showPocketDialog(context, reservation),
                                    child: const Icon(Icons.delete)),
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

  showPocketDialog(BuildContext context, ReservationModel reservationModel) {
    var dialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: const Text(
        'Confirmación',
        overflow: TextOverflow.clip,
        textAlign: TextAlign.center,
      ),
      content: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Seguro(a) de eliminar esta reservación',
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                homeBloc.add(DeleteReservation(reservationModel));
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 15)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  elevation: MaterialStateProperty.all(1),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.blue)))),
              child: const SizedBox(
                width: 200,
                child: Text(
                  'Eliminar',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 15)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(1),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.blue)))),
              child: const SizedBox(
                width: 200,
                child: Text(
                  'cerrar',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return showDialog(context: context, builder: (context) => dialog);
  }
}
