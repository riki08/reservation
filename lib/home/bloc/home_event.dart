part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetReservations extends HomeEvent {}

class CreateReservation extends HomeEvent {}

class DeleteReservation extends HomeEvent {
  final ReservationModel reservationModel;

  DeleteReservation(this.reservationModel);
}
