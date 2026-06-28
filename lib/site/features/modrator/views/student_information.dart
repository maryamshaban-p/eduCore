import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_student_service.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_service.dart';
import 'package:edulink_app/site/features/modrator/views/floating_chat_widget.dart';
import 'package:edulink_app/site/features/modrator/widgets/custom_primaryButton.dart';
import 'package:edulink_app/site/shared_widgets/app_snackbar.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class StudentInformation extends StatefulWidget {
  final String studentId;
  final String studentUserId;
  final String initials;
  final VoidCallback onClose;
  final VoidCallback onRefresh;

  const StudentInformation({
    super.key,
    required this.studentId,
    required this.studentUserId,
    required this.initials,
    required this.onClose,
    required this.onRefresh,
  });

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  final ModeratorStudentService _studentService = ModeratorStudentService();
  final ModeratorService _moderatorService = ModeratorService();

  Map<String, dynamic>? _student;
  List<Map<String, dynamic>> _allTeachers = [];
  List<Map<String, dynamic>> _allCourses = [];
  bool _isLoading = true;
  String? _error;
  bool _showAssign = false;
  bool _showEnroll = false;
  bool _isActionBusy = false;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
String _formatDate(dynamic raw) {
  if (raw == null || raw.toString().isEmpty) return '';
  try {
    final dt = DateTime.parse(raw.toString()).toLocal();
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  } catch (_) {
    return raw.toString();
  }
}
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final s = await _studentService.getStudentDetail(widget.studentId);
      final t = await _moderatorService.getTeachers();
      final c = await _studentService.getCourses();
      if (!mounted) return;
      setState(() {
        _student = s;
        _allTeachers = t;
        _allCourses = c;
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

  Future<void> _removeTeacher(String teacherId, String teacherName) async {
    if (_isActionBusy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Teacher?'),
        content: Text(
            'Are you sure you want to remove "$teacherName" from this student?\nAll related enrollments will also be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isActionBusy = true);
    try {
      final enrollments = (_student?['enrollments'] as List? ?? []);
      for (final enrollment in enrollments) {
        if ((enrollment['teacherName'] ?? '').toString() == teacherName) {
          final courseId = (enrollment['courseId'] ?? '').toString();
          if (courseId.isNotEmpty) {
            try {
              await _studentService.removeEnrollment(
                studentId: widget.studentId,
                courseId: courseId,
              );
            } catch (_) {}
          }
        }
      }

      await _studentService.removeTeacher(
        studentId: widget.studentId,
        teacherId: teacherId,
      );

      if (!mounted) return;
      showSuccessSnackBar(context, 'Teacher removed successfully');
      await _loadData();
      widget.onRefresh();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isActionBusy = false);
    }
  }

  Future<void> _assignTeacher(String tId) async {
    if (_isActionBusy) return;
    setState(() => _isActionBusy = true);
    try {
      await _studentService.assignTeacher(
          studentId: widget.studentId, teacherId: tId);
      if (!mounted) return;
      setState(() => _showAssign = false);
      showSuccessSnackBar(context, 'Teacher assigned successfully');
      await _loadData();
      widget.onRefresh();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isActionBusy = false);
    }
  }

  Future<void> _enrollCourse(String courseId) async {
    if (_isActionBusy) return;
    setState(() => _isActionBusy = true);
    try {
      await _studentService.enrollStudent(
        studentId: widget.studentId,
        courseId: int.parse(courseId),
      );
      if (!mounted) return;
      setState(() => _showEnroll = false);
      showSuccessSnackBar(context, 'Student enrolled successfully');
      await _loadData();
      widget.onRefresh();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isActionBusy = false);
    }
  }

  Future<void> _removeEnrollment(String courseId) async {
    if (_isActionBusy) return;
    setState(() => _isActionBusy = true);
    try {
      await _studentService.removeEnrollment(
        studentId: widget.studentId,
        courseId: courseId,
      );
      if (!mounted) return;
      showSuccessSnackBar(context, 'Enrollment removed successfully');
      await _loadData();
      widget.onRefresh();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isActionBusy = false);
    }
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return '??';
    final p = name.trim().split(' ');
    if (p.length >= 2 && p[1].isNotEmpty) {
      return '${p[0][0]}${p[1][0]}'.toUpperCase();
    }
    return p[0].isNotEmpty ? p[0][0].toUpperCase() : '??';
  }

  List<dynamic> get _assigned => _student?['assignedTeachers'] ?? [];

  List<Map<String, dynamic>> get _unassigned {
    final ids = _assigned
        .map((t) => (t['teacher_id'] ?? t['id'] ?? '').toString())
        .toSet();
    return _allTeachers.where((t) => !ids.contains(t['teacherId'])).toList();
  }

  List<Map<String, dynamic>> get _unenrolledCourses {
    final enrolledIds = (_student?['enrollments'] as List? ?? [])
        .map((e) => (e['courseId'] ?? '').toString())
        .toSet();

    final assignedTeacherIds = _assigned
        .map((t) => (t['teacher_id'] ?? t['id'] ?? '').toString())
        .where((id) => id.isNotEmpty)
        .toSet();
    final assignedTeacherNames = _assigned
        .map((t) => (t['name'] ?? '').toString())
        .where((n) => n.isNotEmpty)
        .toSet();

    return _allCourses.where((c) {
      final notEnrolled = !enrolledIds.contains(c['courseId']);
      if (!notEnrolled) return false;

      final courseTeacherId = (c['teacherId'] ?? '').toString();
      final courseTeacherName = (c['teacherName'] ?? '').toString();

      final matchesAssignedTeacher = (courseTeacherId.isNotEmpty &&
              assignedTeacherIds.contains(courseTeacherId)) ||
          (courseTeacherName.isNotEmpty &&
              assignedTeacherNames.contains(courseTeacherName));

      return matchesAssignedTeacher;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final studentName = (_student?['name'] ?? '').toString();

    // ── Widget عادي (مش Scaffold) عشان السايدبار يفضل ظاهر ──────────────
    return Material(
      color: Colors.white,
      child: Stack(children: [
        Column(children: [
          // ── Breadcrumb Header ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.slate200)),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: widget.onClose,
                child: const Text(
                  'Students',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.slate500,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right,
                    size: 16, color: AppColors.slate400),
              ),
              Text(
                studentName.isEmpty ? 'Student' : studentName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.slate800,
                ),
              ),
            ]),
          ),

          // ── Body ─────────────────────────────────────────────────────
          Expanded(
            child: LoadingErrorView(
              isLoading: _isLoading,
              error: _error,
              onRetry: _loadData,
              builder: (context) => SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.arrow_back_ios_rounded,
                              size: 14, color: AppColors.slate500),
                          SizedBox(width: 6),
                          Text(
                            'Back to Students',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    // ── Student Info Card ──────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.slate200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.slate100,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.initials,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.slate800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      studentName,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.slate800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if ((_student?['userName'] ?? '')
                                        .toString()
                                        .isNotEmpty)
                                      Text(
                                        '@${(_student?['userName'] ?? '')}',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: AppColors.slate500,
                                        ),
                                      ),
                                    const SizedBox(height: 5),
                                  if ((_student?['phoneNumber'] ?? '').toString().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        " +20 ${(_student?['phoneNumber'] ?? '').toString()}",
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: AppColors.slate500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Message Button
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  backgroundColor: AppColors.primaryXL,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
onPressed: () {
  final uid = (_student?['userId'] ?? widget.studentId).toString();
  if (uid.isEmpty) {
    showErrorSnackBar(context, 'No user ID found for this student');
  } else {
    setState(() => _showChat = true);
  }
},
icon: const Icon(
  Icons.chat_bubble_outline_rounded,
  size: 15,
  color: AppColors.primary,
),
                                label: const Text(
                                  'Message',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),Padding(
                            padding: const EdgeInsets.only(left: 88),
                            child: Wrap(children: [
                                if ((_student?['academicLevel'] ?? '').toString().isNotEmpty ||
                                    (_student?['academicYear'] ?? '').toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Education Level: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            color: AppColors.slate800,
                                          ),
                                        ),
                                         Text(
                                          ' ${(_student?['academicLevel'] ?? '')} — ${(_student?['academicYear'] ?? '')}nd Year',
                                          style: TextStyle(
                                           
                                            fontFamily: 'Inter',
                                            fontSize: 13,
                                            color: AppColors.slate500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),SizedBox(width: 16,),
                                if ((_student?['parentPhone'] ?? '').toString().isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        'Parent Phone: ',
                                        style: const TextStyle(
                                           fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: AppColors.slate800,
                                        ),
                                      ),
                                        Text(
                                        ' +20 ${(_student?['parentPhone'] ?? '')}',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: AppColors.slate500,
                                        ),
                                      ),
                                    ],
                                  ),],),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── Enrolled Teachers ──────────────────────────────
                    Row(children: [
                      const Text(
                        'Enrolled Teachers',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate800,
                        ),
                      ),
                      const Spacer(),
                      CustomPrimaryButton(
                        label: 'Add Teacher',
                        icon: Icons.add,
                        onTap: () => setState(() => _showAssign = true),
                      ),
                    ]),
                    const SizedBox(height: 14),

                    if (_assigned.isEmpty)
                      const Text(
                        'No teachers assigned yet.',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: AppColors.slate400),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: (_assigned as List).map((t) {
                          final name = (t['name'] ?? '').toString();
                          final subjectRaw = t['subjects'];
final subject = subjectRaw is List
    ? subjectRaw.join(', ')
    : (subjectRaw ?? '').toString();
                          final teacherId =
                              (t['teacher_id'] ?? t['id'] ?? '').toString();
                          return Container(
                            width: 260,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.slate200),
                            ),
                            child: Row(children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.slate100,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _initials(name),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.slate800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.slate800,
                                      ),
                                    ),
                                    if (subject.isNotEmpty)
                                      Text(
                                        subject,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: AppColors.slate500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 18,
                                icon: const Icon(Icons.delete_outline_rounded,
                                    color: Colors.redAccent),
                                onPressed: () =>
                                    _removeTeacher(teacherId, name),
                              ),
                            ]),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 18),

                    // ── Enrollment History ─────────────────────────────
                    Row(children: [
                      const Text(
                        'Enrollment History',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate800,
                        ),
                      ),
                      const Spacer(),
                      CustomPrimaryButton(
                        label: 'Add Course',
                        icon: Icons.add,
                        onTap: () => setState(() => _showEnroll = true),
                      ),
                    ]),
                    const SizedBox(height: 14),
                    _buildEnrollments(),
                  ],
                ),
              ),
            ),
          ),
        ]),

        // ── Assign Teacher Popup ───────────────────────────────────────────
        if (_showAssign)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showAssign = false),
              child: Container(color: Colors.black.withOpacity(0.25)),
            ),
          ),
        if (_showAssign)
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate200)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('Assign Teacher',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate800)),
                        const Spacer(),
                        IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: AppColors.slate500),
                            onPressed: () =>
                                setState(() => _showAssign = false)),
                      ]),
                      const Divider(height: 20, color: AppColors.slate200),
                      if (_unassigned.isEmpty)
                        const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('All teachers already assigned.',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: AppColors.slate500)))
                      else
                        Flexible(
                            child: ListView(
                                shrinkWrap: true,
                                children: _unassigned
                                    .map((t) => GestureDetector(
                                          onTap: () => _assignTeacher(
                                              t['teacherId'] ?? ''),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.slate200),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Row(children: [
                                              Container(
                                                  width: 34,
                                                  height: 34,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.primaryXL,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      _initials(
                                                          t['teacherName'] ??
                                                              ''),
                                                      style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppColors
                                                              .primary))),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                    Text(
                                                        t['teacherName'] ?? '',
                                                        style: const TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors
                                                                .slate800)),
                                                    Text(t['subject'] ?? '',
                                                        style: const TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontSize: 12,
                                                            color: AppColors
                                                                .slate500)),
                                                  ])),
                                              const Icon(
                                                  Icons
                                                      .add_circle_outline_rounded,
                                                  color: AppColors.primary,
                                                  size: 18),
                                            ]),
                                          ),
                                        ))
                                    .toList())),
                    ]),
              ),
            ),
          ),

        // ── Enroll Course Popup ────────────────────────────────────────────
        if (_showEnroll)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _showEnroll = false),
              child: Container(color: Colors.black.withOpacity(0.25)),
            ),
          ),
        if (_showEnroll)
          Positioned(
            left: 20,
            right: 20,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.slate200)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('Enroll in Course',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.slate800)),
                        const Spacer(),
                        IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: AppColors.slate500),
                            onPressed: () =>
                                setState(() => _showEnroll = false)),
                      ]),
                      const Divider(height: 20, color: AppColors.slate200),
                      if (_unenrolledCourses.isEmpty)
                        const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('All courses already enrolled.',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    color: AppColors.slate500)))
                      else
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: _unenrolledCourses
                                .map((c) => GestureDetector(
                                      onTap: () =>
                                          _enrollCourse(c['courseId'] ?? ''),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.slate200),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Row(children: [
                                          Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                  color: AppColors.primaryXL,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                  Icons.menu_book_rounded,
                                                  size: 16,
                                                  color: AppColors.primary)),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                Text(c['title'] ?? '',
                                                    style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.slate800)),
                                                Text(c['teacherName'] ?? '',
                                                    style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.slate500)),
                                              ])),
                                          const Icon(
                                              Icons.add_circle_outline_rounded,
                                              color: AppColors.primary,
                                              size: 18),
                                        ]),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                    ]),
              ),
            ),
          ),

        // ── Floating Chat ──────────────────────────────────────────────────
        if (_showChat)
          Positioned(
            right: 20,
            bottom: 20,
child: FloatingChatWidget(
  studentId: (_student?['userId'] ?? widget.studentUserId).toString(),
              studentName: (_student?['name'] ?? '').toString().isEmpty
                  ? 'Student'
                  : (_student?['name'] ?? '').toString(),
              studentInitials: widget.initials,
              onClose: () => setState(() => _showChat = false),
            ),
          ),
      ]),
    );
  }

  Widget _buildEnrollments() {
    final enrollments = (_student?['enrollments'] as List? ?? []);
    if (enrollments.isEmpty) {
      return const Text(
        'No enrollments yet.',
        style: TextStyle(
            fontFamily: 'Inter', fontSize: 13, color: AppColors.slate400),
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.slate200)),
      child: Column(children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
              color: AppColors.slate50,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(12))),
          child: const Row(children: [
            Expanded(child: _EH('Teacher')),
            SizedBox(width: 160, child: _EH('Subject')),
            SizedBox(width: 160, child: _EH('Date Enrolled')),
            SizedBox(width: 32),
          ]),
        ),
        const Divider(height: 1, color: AppColors.slate200),
        // Table Rows
        ...enrollments.asMap().entries.map((e) => Column(children: [
              if (e.key > 0)
                const Divider(height: 1, color: AppColors.slate100),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(children: [
                  Expanded(
                    child: Text(
                      (e.value['teacherName'] ?? '').toString(),
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.slate800),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: Text(
                      (e.value['courseTitle'] ??
                              e.value['subject'] ??
                              e.value['courseName'] ??
                              '')
                          .toString(),
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.primary),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: Text(
                      _formatDate(e.value['enrolledAt'] ?? ''),
                      style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.slate500),
                    ),
                  ),
                  _isActionBusy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 16,
                          icon: const Icon(Icons.delete_outline_rounded,
                              color: AppColors.danger),
                          onPressed: () => _removeEnrollment(
                              (e.value['courseId'] ?? '').toString()),
                        ),
                ]),
              ),
            ])),
      ]),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _InfoItem extends StatelessWidget {
  final String text;
  final bool bold;
  const _InfoItem(this.text, {this.bold = false});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: bold ? AppColors.slate700 : AppColors.slate500,
          fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
        ),
      );
}

class _EH extends StatelessWidget {
  final String text;
  const _EH(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.slate500));
}
