import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/home_model.dart';
import '../data/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repo;

  HomeCubit(this._repo) : super(HomeInitial());

  Future<void> loadHome() async {
    emit(HomeLoading());
    try {
      final data = await _repo.getHome();
      emit(HomeLoaded(data));
    } catch (e) {
      emit(HomeError('Failed to load home: $e'));
    }
  }
}