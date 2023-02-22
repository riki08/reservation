part of 'home_bloc.dart';

enum HomeStatus { initial, success, error, loading }

extension HomeStatusX on HomeStatus {
  bool get isInitial => this == HomeStatus.initial;

  bool get isSuccess => this == HomeStatus.success;

  bool get isError => this == HomeStatus.error;

  bool get isLoading => this == HomeStatus.loading;
}

class HomeState extends Equatable {
  HomeState(
      {this.status = HomeStatus.initial,
      List<ReservationModel>? reservations,
      List<CourtModel>? courts})
      : reservations = reservations ?? [];

  final HomeStatus status;
  final List<ReservationModel>? reservations;

  HomeState copyWith({
    HomeStatus? status,
    List<ReservationModel>? reservations,
  }) =>
      HomeState(
        status: status ?? this.status,
        reservations: reservations ?? this.reservations,
      );

  @override
  List<Object?> get props => [status, reservations];
}
