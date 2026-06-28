import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/teacher/services/teacher_student_service.dart';
import 'package:edulink_app/site/features/teacher/views/student_info_screen.dart';
import 'package:edulink_app/site/shared_widgets/custom_data_table.dart';
import 'package:flutter/material.dart';

class MyStudentsScreen extends StatefulWidget {
  const MyStudentsScreen({super.key});

  @override
  State<MyStudentsScreen> createState() => _MyStudentsScreenState();
}

class _MyStudentsScreenState extends State<MyStudentsScreen> {
  final TeacherStudentService _service = TeacherStudentService();
  List<TeacherStudent> _students = [];
  bool _isLoading = true;
  String? _error;

  bool _showStudentDetails = false;
  TeacherStudent? _selectedStudent;
  String? _selectedInitials;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final data = await _service.getStudents();
      setState(() { _students = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
  }

  void _onStudentSelected(TeacherStudent student) {
    setState(() {
      _selectedStudent = student;
      _selectedInitials = _getInitials(student.studentName);
      _showStudentDetails = true;
    });
  }

  void _onBackToList() {
    setState(() {
      _showStudentDetails = false;
      _selectedStudent = null;
      _selectedInitials = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.slate600)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadStudents, child: const Text('Retry')),
          ]),
        ),
      );
    }

    // ── Detail view — full bleed, no extra padding ─────────────────────────
    if (_showStudentDetails && _selectedStudent != null) {
      return StudentInfoScreen(
        student: _selectedStudent!,
        initials: _selectedInitials!,
        onClose: _onBackToList,
      );
    }

    // ── List view ──────────────────────────────────────────────────────────
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Students',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.slate800,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const minW = 700.0;
                final table = CustomDataTable(
                  columns: const [
                    TableColumnDef(label: 'Student',           widthFactor: 0),
                    TableColumnDef(label: 'Education Level',   widthFactor: 0),
                    TableColumnDef(label: 'Lessons Completed', widthFactor: 0),
                    TableColumnDef(label: 'Avg Score',         widthFactor: 0),
                    TableColumnDef(label: 'Last Active',       widthFactor: 0),
                  ],
                  rows: _students.map((s) => [
                    TableCellData(
                      widthFactor: 0,
                      child: studentAvatarCell(
                        initials: _getInitials(s.studentName),
                        name: s.studentName,
                      ),
                    ),
                    TableCellData(
                      widthFactor: 0,
                      child: Text(s.educationLevel,
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.slate600)),
                    ),
                    TableCellData(
                      widthFactor: 0,
                      child: Text('${s.completedLessons}',
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.slate600)),
                    ),
                    TableCellData(
                      widthFactor: 0,
                      child: scoreCell(s.averageScore.toInt()),
                    ),
                    TableCellData(
                      widthFactor: 0,
                      child: Text(
                        s.lastActive == '0001-01-01T00:00:00'
                            ? 'No Activity'
                            : s.lastActive.split('T')[0],
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.slate500),
                      ),
                    ),
                  ]).toList(),
                  onRowTap: (i) => _onStudentSelected(_students[i]),
                );

                if (constraints.maxWidth < minW) {
                  return _HScrollTable(minWidth: minW, child: table);
                }
                return table;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Horizontal scroll wrapper ─────────────────────────────────────────────────
class _HScrollTable extends StatefulWidget {
  final Widget child;
  final double minWidth;
  const _HScrollTable({required this.child, required this.minWidth});

  @override
  State<_HScrollTable> createState() => _HScrollTableState();
}

class _HScrollTableState extends State<_HScrollTable> {
  late final ScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = ScrollController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _ctrl,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _ctrl,
        scrollDirection: Axis.horizontal,
        child: SizedBox(width: widget.minWidth, child: widget.child),
      ),
    );
  }
}