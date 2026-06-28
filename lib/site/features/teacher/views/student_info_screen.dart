import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/teacher/services/teacher_student_service.dart';
import 'package:flutter/material.dart';

class StudentInfoScreen extends StatefulWidget {
  final TeacherStudent student;
  final String initials;
  final VoidCallback onClose;

  const StudentInfoScreen({
    super.key,
    required this.student,
    required this.initials,
    required this.onClose,
  });

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final TeacherStudentService _service = TeacherStudentService();
  StudentDetail? _detail;
  bool _isLoading = true;
  String? _error;

  static const double _kMobile = 480;
  static const double _kTablet = 768;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final data = await _service.getStudentDetail(widget.student.studentId);
      setState(() { _detail = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Sub-header: Back + breadcrumb ──────────────────────────────────
        _buildSubHeader(),

        // ── Content ────────────────────────────────────────────────────────
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? _buildError()
                  : _buildBody(),
        ),
      ],
    );
  }

  // ── Sub-header ────────────────────────────────────────────────────────────
  // مبسوط تحت الـ AppBar الأساسي مباشرة — فيه Back على اليسار
  // وبس، من غير breadcrumb تاني لأن الـ AppBar بيعرضه فوق
  Widget _buildSubHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.slate200)),
      ),
      child: GestureDetector(
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
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
          const SizedBox(height: 12),
          Text(_error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.slate600)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() { _isLoading = true; _error = null; });
              _loadDetail();
            },
            child: const Text('Retry'),
          ),
        ]),
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    final d = _detail!;
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final p = w < _kMobile ? 14.0 : 24.0;
      return SingleChildScrollView(
        padding: EdgeInsets.all(p),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentCard(d, w),
            SizedBox(height: w < _kMobile ? 12 : 20),
            _buildStatCards(d, w),
            SizedBox(height: w < _kMobile ? 12 : 20),
            _buildLessonsTable(d.lessons, w),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  // ── Student card ──────────────────────────────────────────────────────────
  Widget _buildStudentCard(StudentDetail d, double w) {
    final isMobile = w < _kMobile;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 14 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // Avatar
        Container(
          width: isMobile ? 42 : 52,
          height: isMobile ? 42 : 52,
          decoration: BoxDecoration(
            color: AppColors.primaryXL,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.initials,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 15 : 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: isMobile ? 10 : 14),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    d.studentName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Grade: ${d.grade.toInt()}%',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.student.educationLevel,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.slate500,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  // ── Stat cards ────────────────────────────────────────────────────────────
  Widget _buildStatCards(StudentDetail d, double w) {
    final stats = [
      _StatCardData('Average Score',     '${d.averageScore.toInt()}%'),
      _StatCardData('Completion Rate',   '${d.completionRate.toInt()}%'),
      _StatCardData('Lessons Completed', '${widget.student.completedLessons}'),
    ];

    // Mobile → vertical list
    if (w < _kMobile) {
      return Column(
        children: List.generate(stats.length, (i) => Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: i < stats.length - 1 ? 10 : 0),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stats[i].label,
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.slate500)),
              Text(stats[i].value,
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate800)),
            ],
          ),
        )),
      );
    }

    // Tablet / Desktop → horizontal
    return Row(
      children: List.generate(stats.length, (i) => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: i < stats.length - 1 ? 12 : 0),
          padding: EdgeInsets.symmetric(
            vertical: w < _kTablet ? 16 : 22,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Column(children: [
            Text(stats[i].value,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: w < _kTablet ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate800)),
            const SizedBox(height: 6),
            Text(stats[i].label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.slate500)),
          ]),
        ),
      )),
    );
  }

  // ── Lessons table ─────────────────────────────────────────────────────────
  Widget _buildLessonsTable(List<StudentLesson> lessons, double w) {
    const double minTableWidth = 620;

    final tableContent = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(bottom: BorderSide(color: AppColors.slate200)),
            ),
            child: const Row(children: [
              Expanded(flex: 4, child: _HeaderCell('Lesson')),
              Expanded(flex: 2, child: _HeaderCell('Watch %')),
              Expanded(flex: 2, child: _HeaderCell('Views')),
              Expanded(flex: 2, child: _HeaderCell('Entry Test')),
              Expanded(flex: 2, child: _HeaderCell('Result')),
              Expanded(flex: 2, child: _HeaderCell('Homework')),
            ]),
          ),
          if (lessons.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text('No lessons yet',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.slate400)),
              ),
            )
          else
            ...lessons.asMap().entries.map((e) => _LessonRow(
                  lesson: e.value,
                  index: e.key,
                  isLast: e.key == lessons.length - 1,
                )),
        ],
      ),
    );

    if (w < minTableWidth) {
      return _HScrollTable(minWidth: minTableWidth, child: tableContent);
    }
    return tableContent;
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

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.slate500,
        ),
      );
}

class _LessonRow extends StatelessWidget {
  final StudentLesson lesson;
  final int index;
  final bool isLast;

  const _LessonRow({
    required this.lesson,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.slate200)),
      ),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Text('${index + 1} – ${lesson.lessonTitle}',
              style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.slate700)),
        ),
        Expanded(
          flex: 2,
          child: Row(children: [
            SizedBox(
              width: 48,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: lesson.watchPercent / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.slate200,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('${lesson.watchPercent.toInt()}%',
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.slate700)),
          ]),
        ),
        Expanded(
          flex: 2,
          child: Text('${lesson.viewsUsed}/${lesson.totalViews}',
              style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.slate600)),
        ),
        Expanded(
          flex: 2,
          child: Text(
            lesson.entryTest == '-' ? '—' : lesson.entryTest,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: lesson.entryTest == '-'
                  ? AppColors.slate400
                  : AppColors.success,
            ),
          ),
        ),
        Expanded(flex: 2, child: _ResultBadge(result: lesson.result)),
        Expanded(
          flex: 2,
          child: const Text('—',
              style: TextStyle(color: AppColors.slate400, fontSize: 13)),
        ),
      ]),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final String result;
  const _ResultBadge({required this.result});

  @override
  Widget build(BuildContext context) {
    switch (result.toLowerCase()) {
      case 'completed':
      case 'passed':
        return const Row(children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 14, color: AppColors.success),
          SizedBox(width: 4),
          Text('Completed',
              style: TextStyle(
                  fontFamily: 'Inter', fontSize: 12, color: AppColors.success)),
        ]);
      case 'pending':
        return const Row(children: [
          Icon(Icons.hourglass_bottom_rounded,
              size: 14, color: AppColors.warning),
          SizedBox(width: 4),
          Text('Pending',
              style: TextStyle(
                  fontFamily: 'Inter', fontSize: 12, color: AppColors.warning)),
        ]);
      case 'locked':
        return const Row(children: [
          Icon(Icons.lock_outline_rounded,
              size: 14, color: AppColors.slate400),
          SizedBox(width: 4),
          Text('Locked',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.slate400)),
        ]);
      default:
        return const Text('—',
            style: TextStyle(color: AppColors.slate400, fontSize: 13));
    }
  }
}

class _StatCardData {
  final String label, value;
  const _StatCardData(this.label, this.value);
}