part of 'overview_cubit.dart';

abstract class OverviewState {
  const OverviewState();
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}


class OverviewLoaded extends OverviewState {
  final AdminOverviewModel stats;
  final List<ActivityItem> recentActivity;
  final List<EnrollmentEntry> enrollmentData;

  const OverviewLoaded({
    required this.stats,
    required this.recentActivity,
    required this.enrollmentData,
  });
}
class OverviewError extends OverviewState {
  final String message;
  const OverviewError(this.message);
}