import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:reservation_app/home/home_page.dart';
import 'package:reservation_app/models/court_model.dart';
import 'package:reservation_app/models/reservation_model.dart';

import 'home/bloc/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path.getApplicationDocumentsDirectory();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(CourtAdapter())
    ..registerAdapter(ReservationAdapter());

  await Hive.openBox<CourtModel>('courts');
  await Hive.openBox<ReservationModel>('reservations');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const MaterialApp(
        title: 'Court Tennis',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
