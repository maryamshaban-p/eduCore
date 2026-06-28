import 'package:edulink_app/site/features/teacher/services/teacher_subject_service.dart';
import 'package:edulink_app/site/features/teacher/widgets/course_details.dart';
import 'package:edulink_app/site/shared_widgets/custom_textField.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MycoursesScreen extends StatefulWidget {
  const MycoursesScreen({super.key});
  @override
  State<MycoursesScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<MycoursesScreen> {
  final TeacherSubjectService _service = TeacherSubjectService();

  String _selectedFilter = 'All';
  bool _isSidePanelVisible = false;
  bool _showCourseDetails = false;
  int? _selectedCourseId;

  List<TeacherSubject> _subjects = [];
  bool _isLoading = true;
  String? _error;

  final _titleController    = TextEditingController();
  final _levelController    = TextEditingController();
  final _yearController     = TextEditingController();
  final _introController    = TextEditingController();
  PlatformFile? _pickedPicture;
  bool _isCreating = false;

  static const _filters = ['All', 'Primary', 'Preparatory', 'Secondary'];

  @override
  void initState() { super.initState(); _loadSubjects(); }

  @override
  void dispose() {
    _titleController.dispose();
    _levelController.dispose();
    _yearController.dispose();
    _introController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    try {
      final data = await _service.getSubjects();
      setState(() { _subjects = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _pickPicture() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true, // required on web; harmless on mobile/desktop
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedPicture = result.files.first);
    }
  }

  Future<void> _createSubject() async {
    if (_titleController.text.isEmpty || _levelController.text.isEmpty || _yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    setState(() => _isCreating = true);
    try {
      await _service.createSubject(
        title: _titleController.text.trim(),
        academicLevel: _levelController.text.trim(),
        academicYear: int.tryParse(_yearController.text.trim()) ?? 1,
        introduction: _introController.text.trim(),
        picture: _pickedPicture,
      );
      _titleController.clear();
      _levelController.clear();
      _yearController.clear();
      _introController.clear();
      setState(() {
        _isSidePanelVisible = false;
        _isLoading = true;
        _pickedPicture = null;
      });
      await _loadSubjects();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally { setState(() => _isCreating = false); }
  }

  List<TeacherSubject> get _filtered =>
      _subjects.where((s) => _selectedFilter == 'All' || s.academicLevel == _selectedFilter).toList();

  List<String> get _visibleCategories =>
      _filters.skip(1).where((cat) => _filtered.any((s) => s.academicLevel == cat)).toList();

  @override
  Widget build(BuildContext context) {
    // إذا بنعرض course details، نفوّض للـ CourseDetailsScreen بالكامل
    if (_showCourseDetails && _selectedCourseId != null) {
      return CourseDetailsScreen(
        courseId: _selectedCourseId!,
        onBack: () => setState(() { _showCourseDetails = false; _selectedCourseId = null; }),
      );
    }

    return Stack(
      children: [
        // ── Main content ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter bar + Add button
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // ✅ Wrap بيتعامل مع الضيق تلقائي
    Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _filters.map((f) => _FilterChip(
        label: f,
        isSelected: _selectedFilter == f,
        onTap: () => setState(() => _selectedFilter = f),
      )).toList(),
    ),
    const SizedBox(height: 10),
    // ✅ الزرار على سطر لوحده على موبايل
    Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => setState(() => _isSidePanelVisible = true),
        icon: const Icon(Icons.add, color: Colors.white, size: 16),
        label: const Text('Add Subject',
            style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.white)),
      ),
    ),
  ],
),
              const SizedBox(height: 20),

              // Body
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
                            const SizedBox(height: 12),
                            Text(_error!, style: const TextStyle(color: AppColors.slate600)),
                            const SizedBox(height: 12),
                            ElevatedButton(onPressed: () { setState(() { _isLoading = true; _error = null; }); _loadSubjects(); }, child: const Text('Retry')),
                          ]))
                        : _filtered.isEmpty
                            ? const Center(child: Text('No courses found', style: TextStyle(color: AppColors.slate500)))
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _visibleCategories.map((cat) {
                                    final items = _filtered.where((s) => s.academicLevel == cat).toList();
                                    return _SubjectSection(
                                      category: cat,
                                      items: items,
                                      onView: (id) => setState(() { _selectedCourseId = id; _showCourseDetails = true; }),
                                      onDelete: (id) async {
                                        await _service.deleteSubject(id);
                                        setState(() => _isLoading = true);
                                        _loadSubjects();
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
              ),
            ],
          ),
        ),

        // ── Add Subject slide panel ───────────────────────────────────────
        _AddSubjectPanel(
          isVisible: _isSidePanelVisible,
          titleController: _titleController,
          levelController: _levelController,
          yearController: _yearController,
          introController: _introController,
          pickedPicture: _pickedPicture,
          onPickPicture: _pickPicture,
          isCreating: _isCreating,
          onClose: () => setState(() => _isSidePanelVisible = false),
          onSave: _createSubject,
        ),
      ],
    );
  }
}

// ─── Widgets ─────────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? null : Border.all(color: AppColors.slate200),
        ),
        child: Text(label, style: TextStyle(
          fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : AppColors.slate600,
        )),
      ),
    );
  }
}

class _SubjectSection extends StatelessWidget {
  final String category;
  final List<TeacherSubject> items;
  final void Function(int) onView;
  final void Function(int) onDelete;
  const _SubjectSection({required this.category, required this.items, required this.onView, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate700)),
        const SizedBox(height: 12),
        // ✅ LayoutBuilder + Wrap بدل fixed width
        LayoutBuilder(builder: (context, constraints) {
          // كل card تاخد نص العرض على desktop، والعرض كامل على mobile
          final cardWidth = constraints.maxWidth > 600
              ? (constraints.maxWidth - 16) / 2   // 2 cards per row
              : constraints.maxWidth;              // full width on narrow

          return Wrap(
            spacing: 16,
            runSpacing: 14,
            children: items.map((s) => SizedBox(
              width: cardWidth,
              child: _SubjectCard(
                badge: '${s.academicLevel} — Year ${s.academicYear}',
                title: s.title,
                lessons: s.sessionsCount,
                students: s.studentsCount,
                onView: () => onView(s.id),
                onDelete: () => onDelete(s.id),
              ),
            )).toList(),
          );
        }),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String badge, title;
  final int lessons, students;
  final VoidCallback onView, onDelete;
  const _SubjectCard({required this.badge, required this.title, required this.lessons, required this.students, required this.onView, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primaryXL, borderRadius: BorderRadius.circular(6)),
            child: Text(badge, style: const TextStyle(fontFamily: 'Inter', color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.slate800)),
          const SizedBox(height: 6),
          Text('$lessons lessons   $students students', style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate500)),
          const SizedBox(height: 10),
          Row(children: [
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
              onPressed: onView,
              child: const Text('View →', style: TextStyle(fontFamily: 'Inter', color: AppColors.primary, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 8),
            IconButton(
              padding: EdgeInsets.zero, iconSize: 18, constraints: const BoxConstraints(),
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
              onPressed: () async {
                final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: const Text('Delete Subject', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
                  content: const Text('Are you sure? This cannot be undone.', style: TextStyle(fontFamily: 'Inter', color: AppColors.slate600)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: AppColors.danger))),
                  ],
                ));
                if (ok == true) onDelete();
              },
            ),
          ]),
        ],
      ),
    );
  }
}

class _AddSubjectPanel extends StatelessWidget {
  final bool isVisible;
  final TextEditingController titleController, levelController, yearController, introController;
  final PlatformFile? pickedPicture;
  final VoidCallback onPickPicture;
  final bool isCreating;
  final VoidCallback onClose, onSave;
  const _AddSubjectPanel({
    required this.isVisible,
    required this.titleController,
    required this.levelController,
    required this.yearController,
    required this.introController,
    required this.pickedPicture,
    required this.onPickPicture,
    required this.isCreating,
    required this.onClose,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.width.toDouble()
        : 320.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      right: isVisible ? 0 : -w,
      top: 0, bottom: 0, width: w,
      child: Material(
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.12),
        color: Colors.white,
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.slate200))),
            child: Row(children: [
              const Text('Add Subject', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.slate800)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close_rounded, color: AppColors.slate500), onPressed: onClose, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ]),
          ),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _label('Subject Title *'),
              const SizedBox(height: 6),
              custom_textField(controller: titleController, hintText: 'e.g. Mathematics'),
              const SizedBox(height: 20),
              _label('Academic Level *'),
              const SizedBox(height: 6),
              // Dropdown بدل textField عشان المستخدم يختار
              _LevelDropdown(controller: levelController),
              const SizedBox(height: 20),
              _label('Academic Year *'),
              const SizedBox(height: 6),
              custom_textField(controller: yearController, hintText: 'e.g. 1'),
              const SizedBox(height: 20),
              _label('Introduction'),
              const SizedBox(height: 6),
              custom_textField(
                controller: introController,
                hintText: 'Short description of the subject',
              ),
              const SizedBox(height: 20),
              _label('Picture'),
              const SizedBox(height: 6),
              _PicturePicker(picked: pickedPicture, onTap: onPickPicture),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: isCreating ? null : onSave,
                  child: isCreating
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Create Subject', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate700));
}

class _PicturePicker extends StatelessWidget {
  final PlatformFile? picked;
  final VoidCallback onTap;
  const _PicturePicker({required this.picked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.slate50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.slate200),
        ),
        child: picked == null
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, color: AppColors.slate400, size: 22),
                    SizedBox(height: 4),
                    Text('Tap to choose an image',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate400)),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.image_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        picked!.name,
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate800),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _LevelDropdown extends StatefulWidget {
  final TextEditingController controller;
  const _LevelDropdown({required this.controller});
  @override
  State<_LevelDropdown> createState() => _LevelDropdownState();
}

class _LevelDropdownState extends State<_LevelDropdown> {
  static const _levels = ['Primary', 'Preparatory', 'Secondary'];
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.slate200),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selected,
          hint: const Text('Select level', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate400)),
          isExpanded: true,
          items: _levels.map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate800)))).toList(),
          onChanged: (v) { setState(() => _selected = v); widget.controller.text = v ?? ''; },
        ),
      ),
    );
  }
}