import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reservation_app/home/bloc/home_bloc.dart';

class CreateReservationPage extends StatefulWidget {
  const CreateReservationPage({super.key, required this.homeBloc});
  final HomeBloc homeBloc;

  @override
  State<CreateReservationPage> createState() => _CreateReservationPageState();
}

class _CreateReservationPageState extends State<CreateReservationPage> {
  late HomeBloc homeBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    homeBloc = widget.homeBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de reservaciones'),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraint) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 20, right: 20, bottom: 10),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nombre de la persona que reserva:',
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: homeBloc.namePlayerController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (String value) {
                                if (value.isNotEmpty) {
                                  homeBloc.namePlayerController.text = value;
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Este campo es obligatorio';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Fecha:',
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                // width: 90.w,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(0, 0),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        homeBloc.date,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (homeBloc.tmp != '') ...[
                              const SizedBox(height: 20),
                              Text(
                                  'Pronostico del tiempo para esa fecha es: ${homeBloc.tmp}°')
                            ],
                            const SizedBox(height: 30),
                            const Text(
                              'Cancha:',
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              hint: const Text(
                                'Cancha a escoger',
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 7),
                              ),
                              borderRadius: BorderRadius.circular(12),
                              validator: (value) =>
                                  value == null ? "Campo obligatorio" : null,
                              items: homeBloc.menuItems,
                              onSaved: (int? value) {
                                homeBloc.idCourt.text = value!.toString();
                              },
                              onChanged: (int? value) {
                                homeBloc.idCourt.text = value!.toString();
                              },
                            ),
                            const Expanded(child: SizedBox()),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate() &&
                                      homeBloc.date != '') {
                                    homeBloc.add(CreateReservation());
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: const Text(
                                    'Crear Reserva',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  )),
                )),
              );
            },
          );
        },
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));
    if (picked != null) {
      //picked output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      homeBloc.getTemp(formattedDate);

      //formatted date output using intl package =>  2021-03-16
      setState(() {
        homeBloc.date = formattedDate; //set output date to TextField value.
      });
    } else {}
  }
}
