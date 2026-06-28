part of 'home_cubit.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial  extends HomeState {}
class HomeLoading  extends HomeState {}

class HomeLoaded extends HomeState {
  final StudentHomeModel data;
  const HomeLoaded(this.data);
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}