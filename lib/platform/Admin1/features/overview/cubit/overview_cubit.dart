import 'package:edulink_app/platform/Admin1/features/overview/data/models/adminOverview_model.dart';
import 'package:edulink_app/platform/Admin1/features/overview/widgets/chart/enrollment_chart_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repos/overview_repo.dart';

part 'overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  final OverviewRepository _repo;

  OverviewCubit(this._repo) : super(OverviewInitial());

  Future<void> loadOverview() async {
  emit(OverviewLoading());
  try {
    final stats          = await _repo.getStats();
    final activity       = await _repo.getRecentActivity();
    final enrollmentData = await _repo.getEnrollmentData();
    emit(OverviewLoaded(
      stats: stats,
      recentActivity: activity,
      enrollmentData: enrollmentData,
    ));
  } catch (e) {
    emit(OverviewError('Failed to load overview: $e'));
  }
}
}