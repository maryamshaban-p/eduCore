import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_service.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ModeratorService _service = ModeratorService();
  List<Map<String, dynamic>> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.getActivityTimeline();
      if (!mounted) return;
      setState(() {
        _activities = data;
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activity Timeline',
              style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.slate800)),
          const SizedBox(height: 16),

          Expanded(
            child: LoadingErrorView(
              isLoading: _isLoading,
              error: _error,
              onRetry: _loadActivities,
              builder: (context) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: _activities.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.monitor_heart_outlined,
                        message: 'No activity yet',
                      )
                    : ListView.separated(
                        itemCount: _activities.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.slate100),
                        itemBuilder: (_, i) {
                          final a = _activities[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 8, height: 8,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 14),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(a['description'] ?? '', style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate700)),
                                const SizedBox(height: 3),
                                Text(a['timeAgo'] ?? '', style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
                              ])),
                            ]),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}