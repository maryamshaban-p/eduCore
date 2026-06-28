import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/overview_cubit.dart';
import '../data/repos/overview_repo.dart';
import 'stats/stats_grid.dart';
import 'stats/overview_charts_row.dart';

class OverviewBody extends StatelessWidget {
  const OverviewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OverviewCubit(OverviewRepository())..loadOverview(),
      child: const _OverviewView(),
    );
  }
}

class _OverviewView extends StatelessWidget {
  const _OverviewView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewCubit, OverviewState>(
      builder: (context, state) {
        if (state is OverviewLoading || state is OverviewInitial) return const Center(child: CircularProgressIndicator());
        if (state is OverviewError) return Center(child: Text(state.message, style: const TextStyle(color: AppColors.danger)));
        if (state is OverviewLoaded) return _OverviewContent(state: state);
        return const SizedBox();
      },
    );
  }
}

class _OverviewContent extends StatelessWidget {
  final OverviewLoaded state;
  const _OverviewContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.slate200),
        radius: const Radius.circular(8),
        thickness: WidgetStateProperty.all(6),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          StatsGrid(stats: state.stats),
          const SizedBox(height: 24),
          OverviewChartsRow(
  recentActivity: state.recentActivity,
  enrollmentData: state.enrollmentData,
),
        ]),
      ),
    );
  }
}
