import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/core/services/user_session.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_service.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_assignedTeacher_card.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_pieChart_card.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_recentlyAdded_students.dart';
import 'package:edulink_app/site/shared_widgets/custom_statGrid.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class ModratorOverviewScreen extends StatefulWidget {
  const ModratorOverviewScreen({super.key});

  @override
  State<ModratorOverviewScreen> createState() => _ModratorOverviewScreenState();
}

class _ModratorOverviewScreenState extends State<ModratorOverviewScreen> {
  final ModeratorService _service = ModeratorService();

  ModeratorDashboard? _dashboard;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.getDashboard();
      if (!mounted) return;
      setState(() {
        _dashboard = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingErrorView(
      isLoading: _isLoading,
      error: _error,
      onRetry: _loadDashboard,
      builder: (context) {
        final d = _dashboard!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth > 700;

              final teachers = d.assignedTeachers.map((t) {
                final name = t['teacherName'] ?? '';
                return TeacherChip(
                  initials: UserSession.getInitials(name),
                  name: name,
                  subject: t['subject'] ?? '',
                );
              }).toList();

              final recentStudents = d.recentlyAddedStudents.map((s) {
                final name = s['name'] ?? '';
                return StudentRow(
                  initials: UserSession.getInitials(name),
                  name: name,
                  date: s['joinedDate'] ?? '',
                );
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats ──────────────────────────────────────────
                  CustomStatgrid(
                    isWide: isWide,
                    items: [
                      StatItem(
                        label: 'My Students',
                        value: '${d.totalStudents}',
                        icon: Icons.people_outline_rounded,
                        bgColor: AppColors.primaryXL,
                        iconColor: AppColors.primary,
                      ),
                      StatItem(
                        label: 'Active Enrollments',
                        value: '${d.activeEnrollments}',
                        icon: Icons.link_rounded,
                        bgColor: AppColors.infoBg,
                        iconColor: AppColors.info,
                      ),
                      StatItem(
                        label: 'Pending Requests',
                        value: '${d.pendingRequests}',
                        icon: Icons.show_chart_rounded,
                        bgColor: AppColors.warningBg,
                        iconColor: AppColors.warning,
                      ),
                      StatItem(
                        label: 'New This Month',
                        value: '${d.newThisMonth}',
                        icon: Icons.person_add_alt_1_rounded,
                        bgColor: AppColors.successBg,
                        iconColor: AppColors.success,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Assigned Teachers ───────────────────────────────
                  CustomAssignedteacherCard(
                    isWide: isWide,
                    teachers: teachers,
                  ),

                  const SizedBox(height: 20),

                  // ── Charts + Recent ─────────────────────────────────
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomPieChartCard(chartData: d.chartData),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomRecentlyaddedStudents(
                            students: recentStudents,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    CustomPieChartCard(chartData: d.chartData),
                    const SizedBox(height: 20),
                    CustomRecentlyaddedStudents(students: recentStudents),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }
}