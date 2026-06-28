import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_student_service.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_service.dart';
import 'package:edulink_app/site/shared_widgets/app_snackbar.dart';
import 'package:edulink_app/site/shared_widgets/custom_textField.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddStudentPanel extends StatefulWidget {
  final bool isVisible;
  final VoidCallback onClose;

  const AddStudentPanel({super.key, required this.isVisible, required this.onClose});

  @override
  State<AddStudentPanel> createState() => _AddStudentPanelState();
}

class _AddStudentPanelState extends State<AddStudentPanel> {
  final ModeratorStudentService _studentService = ModeratorStudentService();
  final ModeratorService _moderatorService = ModeratorService();

  int _step = 0;
  bool _isSaving = false;

  // Step 1 fields
  final _firstName   = TextEditingController();
  final _lastName    = TextEditingController();
  final _email       = TextEditingController();
  final _phone       = TextEditingController();
  final _parentPhone = TextEditingController();
  String? _selectedLevel;
  final _year        = TextEditingController();

  // Step 2 — teachers
  List<Map<String, dynamic>> _teachers = [];
  List<String> _selectedTeacherIds = [];
  bool _loadingTeachers = false;
  String? _teachersError;

  // Step 3 — courses
  List<Map<String, dynamic>> _allCourses = [];
  List<String> _selectedCourseIds = [];
  bool _loadingCourses = false;
  String? _coursesError;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
    _loadCourses();
  }

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _email, _phone, _parentPhone, _year]) c.dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _loadingTeachers = true;
      _teachersError = null;
    });
    try {
      final data = await _moderatorService.getTeachers();
      if (!mounted) return;
      setState(() => _teachers = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _teachersError = friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loadingTeachers = false);
    }
  }

  Future<void> _loadCourses() async {
    setState(() {
      _loadingCourses = true;
      _coursesError = null;
    });
    try {
      final data = await _studentService.getCourses();
      if (!mounted) return;
      setState(() => _allCourses = data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _coursesError = friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loadingCourses = false);
    }
  }

  // Filter courses down to just the selected teachers'
  List<Map<String, dynamic>> get _filteredCourses {
    final selectedTeacherNames = _teachers
        .where((t) => _selectedTeacherIds.contains(t['teacherId']))
        .map((t) => (t['teacherName'] ?? '').toString())
        .toSet();
    return _allCourses
        .where((c) => selectedTeacherNames.contains(c['teacherName']))
        .toList();
  }

  Future<void> _create() async {
    setState(() => _isSaving = true);
    try {
      // 1. create the student
      final result = await _studentService.createStudent(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        phoneNumber: _phone.text.trim(),
        parentPhoneNumber: _parentPhone.text.trim(),
        academicLevel: _selectedLevel ?? '',
        academicYear: int.tryParse(_year.text.trim()),
        teacherIds: _selectedTeacherIds,
      );

      final studentId = result['studentId']?.toString() ?? '';

      // 2. enroll in selected courses
      if (studentId.isNotEmpty) {
        for (final courseId in _selectedCourseIds) {
          try {
            await _studentService.enrollStudent(
              studentId: studentId,
              courseId:  int.parse(courseId),
            );
          } catch (_) {}
        }
      }

      if (!mounted) return;
      _showCredentials(result['username'] ?? '', result['password'] ?? '');
      _clearAll();
      widget.onClose();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _clearAll() {
    for (final c in [_firstName, _lastName, _email, _phone, _parentPhone, _year]) c.clear();
    setState(() {
      _selectedTeacherIds.clear();
      _selectedCourseIds.clear();
      _step = 0;
      _selectedLevel = null;
    });
  }

  void _showCredentials(String user, String pass) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Student Created!',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Share these credentials with the student:',
              style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate600)),
          const SizedBox(height: 16),
          _CredRow(label: 'Username', value: user),
          const SizedBox(height: 8),
          _CredRow(label: 'Password', value: pass),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done'))],
      ),
    );
  }

  String _initials(String name) {
    final p = name.trim().split(' ');
    if (p.length >= 2 && p[1].isNotEmpty) return '${p[0][0]}${p[1][0]}'.toUpperCase();
    return p[0].isNotEmpty ? p[0][0].toUpperCase() : '??';
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final panelW = sw < 600 ? sw : 340.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      right: widget.isVisible ? 0 : -panelW,
      top: 0, bottom: 0, width: panelW,
      child: Material(
        elevation: 16,
        shadowColor: Colors.black.withOpacity(0.15),
        color: Colors.white,
        child: Column(children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.slate200))),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Add Student',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.slate800)),
                  Text('Step ${_step + 1} of 4',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
                ]),
              ),
              IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.slate500),
                  onPressed: widget.onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints()),
            ]),
          ),

          // ── Progress bar ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: List.generate(4, (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= _step ? AppColors.primary : AppColors.slate200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )),
            ),
          ),

          // ── Step content ──────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildStep(),
            ),
          ),

          // ── Footer buttons ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.slate200))),
            child: Row(children: [
              if (_step > 0)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.slate200),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () => setState(() => _step--),
                  child: const Text('← Back',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate600)),
                ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: _isSaving
                    ? null
                    : () {
                        if (_step < 3) setState(() => _step++);
                        else _create();
                      },
                child: _isSaving
                    ? const SizedBox(width: 16, height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_step == 3 ? 'Create Account' : 'Next →',
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _Step1(
          firstName: _firstName, lastName: _lastName, email: _email,
          phone: _phone, parentPhone: _parentPhone, year: _year,
          selectedLevel: _selectedLevel,
          onLevelChanged: (v) => setState(() => _selectedLevel = v),
        ),
      1 => _Step2(
          teachers: _teachers,
          selectedIds: _selectedTeacherIds,
          loading: _loadingTeachers,
          error: _teachersError,
          onRetry: _loadTeachers,
          initials: _initials,
          onToggle: (id) => setState(() {
            _selectedTeacherIds.contains(id)
                ? _selectedTeacherIds.remove(id)
                : _selectedTeacherIds.add(id);
          }),
        ),
      2 => _Step3Courses(
          courses: _filteredCourses,
          selectedCourseIds: _selectedCourseIds,
          loading: _loadingCourses,
          error: _coursesError,
          onRetry: _loadCourses,
          onToggle: (id) => setState(() {
            _selectedCourseIds.contains(id)
                ? _selectedCourseIds.remove(id)
                : _selectedCourseIds.add(id);
          }),
        ),
      _ => _Step4Review(
          firstName: _firstName.text, lastName: _lastName.text,
          email: _email.text, phone: _phone.text,
          parentPhone: _parentPhone.text, level: _selectedLevel ?? '',
          year: _year.text,
          selectedTeachers: _teachers
              .where((t) => _selectedTeacherIds.contains(t['teacherId']))
              .map((t) => (t['teacherName'] ?? '').toString())
              .toList(),
          selectedCourses: _allCourses
              .where((c) => _selectedCourseIds.contains(c['courseId']))
              .map((c) => (c['title'] ?? '').toString())
              .toList(),
        ),
    };
  }
}

// ── Step 1: Personal info ─────────────────────────────────────────────────────
class _Step1 extends StatelessWidget {
  final TextEditingController firstName, lastName, email, phone, parentPhone, year;
  final String? selectedLevel;
  final ValueChanged<String?> onLevelChanged;

  const _Step1({
    required this.firstName, required this.lastName, required this.email,
    required this.phone, required this.parentPhone, required this.year,
    required this.selectedLevel, required this.onLevelChanged,
  });

  static const _levels = ['Primary', 'Preparatory', 'Secondary'];

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Personal Information'),
      const SizedBox(height: 16),
      _Field('First Name *', child: custom_textField(controller: firstName, hintText: 'e.g. Ahmed')),
      _Field('Last Name *',  child: custom_textField(controller: lastName,  hintText: 'e.g. Hassan')),
      _Field('Email *',      child: custom_textField(controller: email,     hintText: 'student@email.com')),
      _Field('Phone',        child: custom_textField(controller: phone,     hintText: '+20 10...')),
      _Field('Parent Phone', child: custom_textField(controller: parentPhone, hintText: '+20 10...')),
      _Field('Academic Level *', child: _LevelDropdown(selected: selectedLevel, onChanged: onLevelChanged, levels: _levels)),
      _Field('Academic Year *',  child: custom_textField(controller: year, hintText: 'e.g. 1')),
    ]);
  }
}

// ── Step 2: Assign teachers ───────────────────────────────────────────────────
class _Step2 extends StatelessWidget {
  final List<Map<String, dynamic>> teachers;
  final List<String> selectedIds;
  final bool loading;
  final String? error;
  final VoidCallback onRetry;
  final String Function(String) initials;
  final void Function(String) onToggle;

  const _Step2({
    required this.teachers, required this.selectedIds,
    required this.loading, required this.error, required this.onRetry,
    required this.initials, required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Assign Teachers'),
      const SizedBox(height: 4),
      const Text('Select at least one teacher.',
          style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate500)),
      const SizedBox(height: 16),
      if (loading)
        const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
      else if (error != null)
        _InlineRetry(message: error!, onRetry: onRetry)
      else
        ...teachers.map((t) {
          final id  = t['teacherId'] ?? '';
          final sel = selectedIds.contains(id);
          return GestureDetector(
            onTap: () => onToggle(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sel ? AppColors.primaryXL : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: sel ? AppColors.primary : AppColors.slate200,
                    width: sel ? 1.5 : 1),
              ),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                      color: sel ? AppColors.primary.withOpacity(0.12) : AppColors.slate100,
                      borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Text(initials(t['teacherName'] ?? ''),
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700,
                          color: sel ? AppColors.primary : AppColors.slate600)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t['teacherName'] ?? '',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500,
                          color: sel ? AppColors.primary : AppColors.slate800)),
                  Text(t['subject'] ?? '',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate500)),
                ])),
                if (sel) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
              ]),
            ),
          );
        }),
    ]);
  }
}

// ── Step 3: Enroll in courses ─────────────────────────────────────────────────
class _Step3Courses extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final List<String> selectedCourseIds;
  final bool loading;
  final String? error;
  final VoidCallback onRetry;
  final void Function(String) onToggle;

  const _Step3Courses({
    required this.courses, required this.selectedCourseIds,
    required this.loading, required this.error, required this.onRetry,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Enroll in Courses'),
      const SizedBox(height: 4),
      const Text('Select courses for this student.',
          style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate500)),
      const SizedBox(height: 16),
      if (loading)
        const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
      else if (error != null)
        _InlineRetry(message: error!, onRetry: onRetry)
      else if (courses.isEmpty)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.slate200)),
          child: const Row(children: [
            Icon(Icons.info_outline_rounded, color: AppColors.slate400, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text('No courses available for the selected teachers.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate500)),
            ),
          ]),
        )
      else
        ...courses.map((c) {
          final id  = c['courseId'] ?? '';
          final sel = selectedCourseIds.contains(id);
          return GestureDetector(
            onTap: () => onToggle(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sel ? AppColors.primaryXL : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: sel ? AppColors.primary : AppColors.slate200,
                    width: sel ? 1.5 : 1),
              ),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                      color: sel ? AppColors.primary.withOpacity(0.12) : AppColors.slate100,
                      borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Icon(Icons.menu_book_rounded,
                      size: 18, color: sel ? AppColors.primary : AppColors.slate400),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c['title'] ?? '',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500,
                          color: sel ? AppColors.primary : AppColors.slate800)),
                  Text(c['teacherName'] ?? '',
                      style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate500)),
                ])),
                if (sel) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
              ]),
            ),
          );
        }),
    ]);
  }
}

// ── Step 4: Review ────────────────────────────────────────────────────────────
class _Step4Review extends StatelessWidget {
  final String firstName, lastName, email, phone, parentPhone, level, year;
  final List<String> selectedTeachers;
  final List<String> selectedCourses;

  const _Step4Review({
    required this.firstName, required this.lastName, required this.email,
    required this.phone, required this.parentPhone, required this.level,
    required this.year, required this.selectedTeachers, required this.selectedCourses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionTitle('Confirm & Create'),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.slate50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.slate200)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ReviewRow('Name',         '$firstName $lastName'),
          _ReviewRow('Email',        email),
          if (phone.isNotEmpty) _ReviewRow('Phone', phone),
          _ReviewRow('Level',        '$level — Year $year'),
          if (parentPhone.isNotEmpty) _ReviewRow('Parent Phone', parentPhone),
          _ReviewRow('Teachers',     selectedTeachers.isEmpty ? 'None selected' : selectedTeachers.join(', ')),
          _ReviewRow('Courses',      selectedCourses.isEmpty  ? 'None selected' : selectedCourses.join(', ')),
        ]),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: AppColors.infoBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.info.withOpacity(0.3))),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text('Login credentials will be auto-generated and shown after creation.',
                style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.info)),
          ),
        ]),
      ),
    ]);
  }
}

class _ReviewRow extends StatelessWidget {
  final String label, value;
  const _ReviewRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(
        text: TextSpan(children: [
      TextSpan(text: '$label: ',
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate700)),
      TextSpan(text: value,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate600)),
    ])),
  );
}

// ── Shared helpers ────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate800));
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;
  const _Field(this.label, {required this.child});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate700)),
      const SizedBox(height: 6),
      child,
    ]),
  );
}

class _LevelDropdown extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  final List<String> levels;
  const _LevelDropdown({required this.selected, required this.onChanged, required this.levels});

  @override
  Widget build(BuildContext context) => Container(
    height: 40,
    decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.slate200)),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selected,
        isExpanded: true,
        hint: const Text('Select level',
            style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate400)),
        items: levels
            .map((l) => DropdownMenuItem(
                value: l,
                child: Text(l, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate800))))
            .toList(),
        onChanged: onChanged,
      ),
    ),
  );
}

class _CredRow extends StatelessWidget {
  final String label, value;
  const _CredRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.slate200)),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.slate500)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate800)),
      ])),
      IconButton(
        icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.slate500),
        onPressed: () => Clipboard.setData(ClipboardData(text: value)),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    ]),
  );
}

/// Small inline error + retry block used inside step 2/3 of the wizard
/// (a full-screen LoadingErrorView would be too heavy for a sub-section).
class _InlineRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _InlineRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.slate200)),
    child: Column(children: [
      Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate600)),
      const SizedBox(height: 10),
      OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
    ]),
  );
}