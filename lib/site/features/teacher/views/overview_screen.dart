import 'package:edulink_app/site/features/teacher/services/teacher_service.dart';
import 'package:edulink_app/site/features/teacher/widgets/recent_studentHomework_submission.dart';
import 'package:edulink_app/site/features/teacher/widgets/student_activity_chart.dart';
import 'package:edulink_app/site/shared_widgets/custom_statGrid.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class TeacherOverviewScreen extends StatefulWidget {
  const TeacherOverviewScreen({super.key});

  @override
  State<TeacherOverviewScreen> createState() => _TeacherOverviewScreenState();
}

class _TeacherOverviewScreenState extends State<TeacherOverviewScreen> {
  final TeacherService _service = TeacherService();

  TeacherDashboard? _dashboard;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await _service.getDashboard();
      setState(() {
        _dashboard = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(_error!,
                style: const TextStyle(color: AppColors.slate600)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadDashboard();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final d = _dashboard!;
    final isWide = MediaQuery.of(context).size.width > 820;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomStatgrid(
            isWide: isWide,
            items: [
              StatItem(
                label: 'Total Subjects',
                value: '${d.totalSubjects}',
                icon: Icons.menu_book_outlined,
                bgColor: AppColors.primaryXL,
                iconColor: AppColors.primary,
              ),
              StatItem(
                label: 'My Students',
                value: '${d.totalStudents}',
                icon: Icons.people_alt_outlined,
                bgColor: AppColors.successBg,
                iconColor: AppColors.success,
              ),
              StatItem(
                label: 'Total Lessons',
                value: '${d.totalSessions}',
                icon: Icons.play_circle_outline,
                bgColor: AppColors.infoBg,
                iconColor: AppColors.info,
              ),
              StatItem(
                label: 'Pending Requests',
                value: '${d.pendingRequests}',
                icon: Icons.notifications_none_outlined,
                bgColor: AppColors.warningBg,
                iconColor: AppColors.warning,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ✅ لو wide: جمب بعض، لو narrow: تحت بعض
          if (isWide)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: StudentActivityChart(
                      activityData: d.studentActivityLast30Days,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    flex: 2,
                    child: RecentHomeworkSubmissions(),
                  ),
                ],
              ),
            )
          else ...[
            StudentActivityChart(
              activityData: d.studentActivityLast30Days,
            ),
            const SizedBox(height: 20),
            const RecentHomeworkSubmissions(),
          ],
        ],
      ),
    );
  }
}