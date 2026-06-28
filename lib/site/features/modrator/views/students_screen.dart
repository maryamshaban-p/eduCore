import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_student_service.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_service.dart';
import 'package:edulink_app/site/features/modrator/widgets/AddStudent%20widgets/add_student_panel.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_filter_dropdown.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_primaryButton.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_search_bar.dart';
import 'package:edulink_app/site/features/modrator/views/student_information.dart';
import 'package:edulink_app/site/shared_widgets/custom_data_table.dart';
import 'package:edulink_app/site/shared_widgets/app_snackbar.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});
  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ModeratorStudentService _studentService = ModeratorStudentService();
  final ModeratorService _moderatorService = ModeratorService();

  List<ModeratorStudent> _allStudents = [];
  List<Map<String, dynamic>> _teachers = [];
  bool _isLoading = true;
  String? _error;

  String? _deletingStudentId;

  bool _addVisible = false;
  String _selectedTeacher = 'All Teachers';
  String _searchQuery = '';

  // Details panel state
  bool _showDetails = false;
  String? _selectedStudentId;
  String? _selectedStudentUserId;
  String? _selectedStudentInitials;

  List<String> get _teacherNames => [
        'All Teachers',
        ..._teachers
            .map((t) => (t['teacherName'] ?? '').toString())
            .where((n) => n.isNotEmpty),
      ];

  List<ModeratorStudent> get _filtered => _allStudents.where((s) {
        final matchT = _selectedTeacher == 'All Teachers' ||
            s.teachers.contains(_selectedTeacher);
        final matchS = _searchQuery.isEmpty ||
            s.name.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchT && matchS;
      }).toList();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _showDeleteConfirmation(
      String studentId, String studentName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student?'),
        content: Text(
            'Are you sure you want to delete "$studentName"?\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _deletingStudentId = studentId);
    try {
      await _studentService.deleteStudent(studentId);
      if (!mounted) return;
      showSuccessSnackBar(context, 'Student deleted successfully');
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _deletingStudentId = null);
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final students = await _studentService.getStudents();
      final teachers = await _moderatorService.getTeachers();
      if (!mounted) return;
      setState(() {
        _allStudents = students;
        _teachers = teachers;
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
    final sw = MediaQuery.of(context).size.width;
    final isMobile = sw < 600;

    return Stack(children: [
      // ── Students Table ────────────────────────────────────────────────────
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toolbar
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CustomSearchBar(
                    hintText: 'Search students...',
                    onChanged: (v) => setState(() => _searchQuery = v)),
                CustomFilterDropdown(
                    options: _teacherNames,
                    selectedValue: _selectedTeacher,
                    onChanged: (v) => setState(() => _selectedTeacher = v)),
                if (!isMobile) const SizedBox(width: 20),
                CustomPrimaryButton(
                    label: 'Add Student',
                    icon: Icons.add,
                    onTap: () => setState(() => _addVisible = true)),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: LoadingErrorView(
                isLoading: _isLoading,
                error: _error,
                onRetry: _loadData,
                builder: (context) => SingleChildScrollView(
                  child: CustomDataTable(
                    minWidth: 820,
                    columns: const [
                      TableColumnDef(label: 'Student', widthFactor: 0.16),
                      TableColumnDef(
                          label: 'Education\nLevel', widthFactor: 0.13),
                      TableColumnDef(label: 'Teachers', widthFactor: 0),
                      TableColumnDef(label: 'Subjects', widthFactor: 0),
                      TableColumnDef(label: 'AVG\nScore', widthFactor: 0.08),
                      TableColumnDef(
                          label: 'Missing\nDays', widthFactor: 0.09),
                      TableColumnDef(label: 'Joined', widthFactor: 0.11),
                      TableColumnDef(label: 'Actions', widthFactor: 0.1),
                    ],
                    rows: _filtered.map((s) => [
                          TableCellData(
                              widthFactor: 0.16,
                              child: studentAvatarCell(
                                  initials: s.initials, name: s.name)),
                          TableCellData(
                              widthFactor: 0.13,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(s.academicLevel,
                                    style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: AppColors.slate500)),
                              )),
                          TableCellData(
                              widthFactor: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Text(s.teachers,
                                    style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: AppColors.slate500)),
                              )),
                          TableCellData(
                              widthFactor: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: Text(s.subjects,
                                    style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: AppColors.slate500)),
                              )),
                          TableCellData(
                              widthFactor: 0.08,
                              child: scoreCell(s.avgScore.toInt())),
                          TableCellData(
                              widthFactor: 0.09,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text('${s.missingDays}',
                                    style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: AppColors.slate500)),
                              )),
                          TableCellData(
                              widthFactor: 0.11,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(s.joinedDate,
                                    style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: AppColors.slate500)),
                              )),
                          TableCellData(
                              widthFactor: 0.1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: _deletingStudentId == s.studentId
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            iconSize: 16,
                                            icon: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                color: AppColors.slate500),
                                            onPressed: () => setState(() {
                                              _selectedStudentId = s.studentId;
                                              _selectedStudentUserId = s.userId;
                                              _selectedStudentInitials =
                                                  s.initials;
                                              _showDetails = true;
                                            }),
                                          ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            iconSize: 16,
                                            icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.redAccent),
                                            onPressed: () =>
                                                _showDeleteConfirmation(
                                                    s.studentId, s.name),
                                          ),
                                        ],
                                      ),
                              )),
                        ]).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Add Student Panel ─────────────────────────────────────────────────
      AddStudentPanel(
        isVisible: _addVisible,
        onClose: () {
          setState(() => _addVisible = false);
          _loadData();
        },
      ),

      // ── Student Details — يملأ كل مساحة الـ body (السايدبار يفضل ظاهر) ──
      if (_showDetails && _selectedStudentId != null)
        Positioned.fill(
          child: StudentInformation(
            studentId: _selectedStudentId!,
            studentUserId: _selectedStudentUserId ?? '',
            initials: _selectedStudentInitials ?? '',
            onClose: () => setState(() => _showDetails = false),
            onRefresh: _loadData,
          ),
        ),
    ]);
  }
}