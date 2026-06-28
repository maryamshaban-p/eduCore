import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/widgets/table/pie_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/reports_cubit.dart';
import '../data/reports_repo.dart';
import 'charts/line_chart_card.dart';

class ReportsBody extends StatelessWidget {
  const ReportsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit(ReportsRepository())..loadReports(),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading || state is ReportsInitial)
          return const Center(child: CircularProgressIndicator());
        if (state is ReportsError)
          return Center(child: Text(state.message,
              style: const TextStyle(color: AppColors.danger)));
        if (state is ReportsLoaded) return _ReportsContent(state: state);
        return const SizedBox();
      },
    );
  }
}

class _ReportsContent extends StatelessWidget {
  final ReportsLoaded state;
  const _ReportsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _ChartsRow(state: state),
      ]),
    );
  }
}

class _ChartsRow extends StatelessWidget {
  final ReportsLoaded state;
  const _ChartsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final line = LineChartCard(data: state.enrollmentBySubject);
    final pie  = PieChartCard(data: state.studentsPerTeacher);
    return LayoutBuilder(builder: (_, c) => c.maxWidth > 800
        ? Row(crossAxisAlignment: CrossAxisAlignment.center, 
           mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Expanded(flex: 3, child: line),
            const SizedBox(width: 24),
            Expanded(flex: 2, child: pie),
          ])
        : Column(children: [line, const SizedBox(height: 24), pie]));
  }
}