import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/achievement_model.dart';
import '../data/achievement_repo.dart';

part 'achievement_state.dart';

class AchievementCubit extends Cubit<AchievementState> {
  final AchievementRepository _repo;

  AchievementCubit(this._repo) : super(AchievementInitial());

  Future<void> loadAchievement() async {
    emit(AchievementLoading());
    try {
      final data = await _repo.getAchievement();
      emit(AchievementLoaded(data));
    } catch (e) {
      emit(AchievementError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}