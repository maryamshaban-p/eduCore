import 'package:edulink_app/site/features/teacher/services/teacher_request_service.dart';
import 'package:edulink_app/site/shared_widgets/custom_data_table.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});
  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final TeacherRequestService _service = TeacherRequestService();
  int _selectedTab = 0;
  List<Map<String, dynamic>> _requests = [];
  bool _isLoading = true;
  bool _actionInProgress = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    try {
      final data = await _service.getRequests();
      if (mounted) setState(() { _requests = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  List<Map<String, dynamic>> get _viewExt =>
      _requests.where((r) => r['type'] == 'view').toList();

  List<Map<String, dynamic>> get _testUnlock =>
      _requests.where((r) => r['type'] == 'test').toList();

  List<Map<String, dynamic>> get _current =>
      _selectedTab == 0 ? _viewExt : _testUnlock;

  Future<void> _approve(String id) async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);
    try {
      await _service.approveRequest(id);
      await _loadRequests();
    } catch (e) {
      _showSnack('Failed to approve: $e');
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<void> _reject(String id) async {
    if (_actionInProgress) return;
    setState(() => _actionInProgress = true);
    try {
      await _service.rejectRequest(id);
      await _loadRequests();
    } catch (e) {
      _showSnack('Failed to reject: $e');
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Widget _buildActionCell(Map<String, dynamic> r) {
    final status = r['status']?.toString() ?? 'Pending';

    if (status == 'Pending') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionBadge(
            label: 'Approve',
            color: AppColors.success,
            bg: AppColors.successBg,
            onTap: () => _approve(r['id'].toString()),
          ),
          const SizedBox(width: 6),
          _ActionBadge(
            label: 'Reject',
            color: AppColors.danger,
            bg: AppColors.dangerBg,
            onTap: () => _reject(r['id'].toString()),
          ),
        ],
      );
    }

    // Approved / Rejected / Denied — show status badge
    final isApproved = status == 'Approved';
    final color = isApproved ? AppColors.success : AppColors.danger;
    final bg    = isApproved ? AppColors.successBg : AppColors.dangerBg;
    final icon  = isApproved ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final label = isApproved ? 'Approved' : 'Rejected';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tabs ──────────────────────────────────────────────────────
          Row(children: [
            _Tab(
              label: 'View Extension (${_viewExt.length})',
              isSelected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0),
            ),
            const SizedBox(width: 8),
            _Tab(
              label: 'Test Unlock (${_testUnlock.length})',
              isSelected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ]),
          const SizedBox(height: 16),

          // ── Body ──────────────────────────────────────────────────────
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Expanded(
              child: ErrorRetry(
                message: _error!,
                onRetry: () {
                  setState(() { _isLoading = true; _error = null; });
                  _loadRequests();
                },
              ),
            )
          else
            Expanded(
              child: _actionInProgress
                  ? const Center(child: CircularProgressIndicator())
                  : CustomDataTable(
                      columns: const [
                        TableColumnDef(label: 'Student', widthFactor: 0),
                        TableColumnDef(label: 'Lesson',  widthFactor: 0),
                        TableColumnDef(label: 'Count',   widthFactor: 0.08),
                        TableColumnDef(label: 'Reason',  widthFactor: 0),
                        TableColumnDef(label: 'Date',    widthFactor: 0.12),
                        TableColumnDef(label: 'Action',  widthFactor: 0.18),
                      ],
                      rows: _current.map((r) => [
                        TableCellData(
                          widthFactor: 0,
                          child: Text(
                            r['student'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.slate800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TableCellData(
                          widthFactor: 0,
                          child: Text(
                            r['lesson'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.slate600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TableCellData(
                          widthFactor: 0.08,
                          child: Text(
                            '${r['count'] ?? ''}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.slate600,
                            ),
                          ),
                        ),
                        TableCellData(
                          widthFactor: 0,
                          child: Text(
                            r['reason'] ?? '',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.slate600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TableCellData(
                          widthFactor: 0.12,
                          child: Text(
                            r['date'] != null
                                ? r['date'].toString().substring(0, 10)
                                : '',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.slate500,
                            ),
                          ),
                        ),
                        TableCellData(
                          widthFactor: 0.18,
                          child: _buildActionCell(r),
                        ),
                      ]).toList(),
                    ),
            ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.slate200,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.slate600,
        ),
      ),
    ),
  );
}

class _ActionBadge extends StatelessWidget {
  final String label;
  final Color color, bg;
  final VoidCallback onTap;
  const _ActionBadge({
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    ),
  );
}