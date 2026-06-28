import 'package:edulink_app/core/services/user_session.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/teacher/services/teacher_subject_service.dart';
import 'package:edulink_app/site/features/teacher/widgets/add_Lesson.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseDetailsScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int courseId;

  const CourseDetailsScreen({
    super.key,
    required this.onBack,
    required this.courseId,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final TeacherSubjectService _service = TeacherSubjectService();
  bool isAddLessonVisible = false;
  Map<String, dynamic>? _courseDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourseDetail();
  }

  Future<void> _loadCourseDetail() async {
    try {
      final data = await _service.getSubjectDetail(widget.courseId);
      setState(() { _courseDetail = data; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _deleteLesson(int lessonId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Lesson',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to delete this lesson?',
            style: TextStyle(fontFamily: 'Inter', color: AppColors.slate600)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (confirm == true) {
      await _service.deleteLesson(lessonId);
      setState(() => _isLoading = true);
      _loadCourseDetail();
    }
  }

  // ── Stats modal ────────────────────────────────────────────────────────
  Future<void> _showLessonStats(int lessonId) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _LessonStatsDialog(
        lessonId: lessonId,
        service: _service,
      ),
    );
  }

  List<dynamic> get _sessions => _courseDetail?['sessions'] ?? [];

  @override
  Widget build(BuildContext context) {
    final courseTitle = _courseDetail != null
        ? '${_courseDetail!['title']} — Year ${_courseDetail!['academicYear']}'
        : 'Loading...';

    return Scaffold(
      backgroundColor: AppColors.slate50,
      body: Stack(
        children: [
          Positioned.fill(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.danger, size: 40),
                            const SizedBox(height: 12),
                            Text('Failed to load course',
                                style:
                                    TextStyle(color: AppColors.danger)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                  _error = null;
                                });
                                _loadCourseDetail();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Top bar ──────────────────────────────
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: widget.onBack,
                                  icon: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 14,
                                      color: AppColors.slate600),
                                  label: const Text('Back to Courses',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: AppColors.slate600)),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  onPressed: () => setState(
                                      () => isAddLessonVisible = true),
                                  icon: const Icon(Icons.add,
                                      color: Colors.white, size: 18),
                                  label: const Text('Add Lesson',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ── Course info card ─────────────────────
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: AppColors.slate200),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(courseTitle,
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.slate800)),
                                  const SizedBox(height: 6),
                                  Text('${_sessions.length} lessons',
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: AppColors.slate500)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Lessons table ────────────────────────
                            _LessonsTable(
                                sessions: _sessions,
                                onDelete: _deleteLesson,
                                onStats: _showLessonStats),
                          ],
                        ),
                      ),
          ),
          AddLesson(
            isVisible: isAddLessonVisible,
            onClose: () {
              setState(() => isAddLessonVisible = false);
              setState(() => _isLoading = true);
              _loadCourseDetail();
            },
            courseId: widget.courseId,
          ),
        ],
      ),
    );
  }
}

// ── Table ─────────────────────────────────────────────────────────────────────

class _LessonsTable extends StatelessWidget {
  final List<dynamic> sessions;
  final void Function(int) onDelete;
  final void Function(int) onStats;

  const _LessonsTable({
    required this.sessions,
    required this.onDelete,
    required this.onStats,
  });

  @override
  Widget build(BuildContext context) {
    const double minTableWidth = 680;

    final table = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            _buildHeader(),
            if (sessions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Text('No lessons found',
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.slate400)),
                ),
              )
            else
              ...sessions.asMap().entries.map((entry) => _LessonRow(
                    index: entry.key + 1,
                    session: entry.value,
                    onDelete: onDelete,
                    onStats: onStats,
                    isLast: entry.key == sessions.length - 1,
                  )),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < minTableWidth) {
          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(width: minTableWidth, child: table),
            ),
          );
        }
        return table;
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xffF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xffE2E8F0))),
      ),
      child: const Row(
        children: [
          SizedBox(width: 36, child: _HeaderCell('#')),
          Expanded(flex: 4, child: _HeaderCell('Lesson Title')),
          Expanded(flex: 3, child: _HeaderCell('Avg Progress')),
          Expanded(flex: 2, child: _HeaderCell('Views')),
          //Expanded(flex: 2, child: _HeaderCell('Homework')),
          Expanded(flex: 2, child: _HeaderCell('Entry Test')),
          Expanded(
              flex: 2,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: _HeaderCell('Actions'))),
        ],
      ),
    );
  }
}

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
          color: Color(0xff64748B),
        ),
      );
}

// ── Row ───────────────────────────────────────────────────────────────────────

class _LessonRow extends StatefulWidget {
  final int index;
  final dynamic session;
  final void Function(int) onDelete;
  final void Function(int) onStats;
  final bool isLast;

  const _LessonRow({
    required this.index,
    required this.session,
    required this.onDelete,
    required this.onStats,
    required this.isLast,
  });

  @override
  State<_LessonRow> createState() => _LessonRowState();
}

class _LessonRowState extends State<_LessonRow> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.session ?? {};

    final progress = double.tryParse('${s['avgProgress'] ?? 0}') ?? 0;
    final hasEntry = s['hasEntryTest'] == true;
    // final homeworkUrl = s['homeworkUrl']?.toString() ?? '';
    // final hasHomework = homeworkUrl.trim().isNotEmpty;
     final views = double.tryParse('${s['avgViews'] ?? 0}') ?? 0;    
     //final homeworkCompleted =
    //     int.tryParse('${s['homeworkCompleted'] ?? 0}') ?? 0;
    // final studentsCount =
    //     int.tryParse('${s['studentsCount'] ?? 0}') ?? 0;
     final lessonId = int.tryParse('${s['id'] ?? 0}') ?? 0;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hovered ? const Color(0xffFAFAFA) : Colors.white,
          border: widget.isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xffF1F5F9))),
        ),
        child: Row(
          children: [
            // #
            SizedBox(
              width: 36,
              child: Text('${widget.index}',
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.slate500)),
            ),

            // Lesson Title
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  s['title']?.toString() ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0F172A)),
                ),
              ),
            ),

            // Avg Progress
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: (progress / 100).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: const Color(0xffE5E7EB),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${progress.toInt()}%',
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate600)),
                  ],
                ),
              ),
            ),

            // Views
            Expanded(
              flex: 2,
              child: Text(
                '${views.toStringAsFixed(views % 1 == 0 ? 0 : 1)} avg',
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.slate600),
              ),
            ),

            // Homework
            // Expanded(
            //   flex: 2,
            //   child: Text(
            //     hasHomework ? '$homeworkCompleted/$studentsCount' : 'N/A',
            //     style: const TextStyle(
            //         fontFamily: 'Inter',
            //         fontSize: 13,
            //         color: AppColors.slate600),
            //   ),
            // ),

            // Entry Test
            Expanded(
              flex: 2,
              child: hasEntry ? _configuredBadge() : _naBadge(),
            ),

            // Actions
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => widget.onStats(lessonId),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text('Stats',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () =>
                        widget.onDelete(s['id'] ?? 0),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.delete_outline_rounded,
                          size: 16, color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _configuredBadge() => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xffDCFCE7),
            borderRadius: BorderRadius.circular(999)),
        child: const Text('✓ Configured',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xff16A34A))),
      );

  Widget _naBadge() => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xffF1F5F9),
            borderRadius: BorderRadius.circular(999)),
        child: const Text('N/A',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xff64748B))),
      );
}

// ── Lesson Stats Dialog ─────────────────────────────────────────────────────
//
// Shown on top of CourseDetailsScreen when "Stats" is tapped on a lesson
// row. Fetches GET /teacher/lessons/{lessonId}/stats and renders only the
// fields that endpoint actually returns: studentName, views, progress,
// lastWatched, entryTest{status, score}. No Homework column — the real
// API has no homework data in this response.

class _LessonStatsDialog extends StatefulWidget {
  final int lessonId;
  final TeacherSubjectService service;

  const _LessonStatsDialog({required this.lessonId, required this.service});

  @override
  State<_LessonStatsDialog> createState() => _LessonStatsDialogState();
}

class _LessonStatsDialogState extends State<_LessonStatsDialog> {
  LessonStats? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final stats = await widget.service.getLessonStats(widget.lessonId);
      setState(() {
        _stats = stats;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isNarrow = screenWidth < 700;

    // Responsive sizing: near-fullscreen on mobile, comfortably wide
    // (capped) on desktop — matches the modal-over-page look from the
    // reference screenshots on both breakpoints.
    final dialogWidth = isNarrow ? screenWidth * 0.94 : 900.0;
    final dialogMaxHeight = screenHeight * 0.85;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 12 : 24,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: dialogMaxHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _stats != null
                          ? 'Lesson Stats — ${_stats!.lessonTitle}'
                          : 'Lesson Stats',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.slate800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.slate500),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xffE2E8F0)),
              const SizedBox(height: 12),

              // ── Body ────────────────────────────────────────────
              Flexible(
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _error != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: AppColors.danger, size: 36),
                                  const SizedBox(height: 10),
                                  Text(_error!,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          color: AppColors.slate600)),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                        _error = null;
                                      });
                                      _load();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _StatsTable(rows: _stats?.data ?? const []),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsTable extends StatelessWidget {
  final List<StudentLessonStat> rows;
  const _StatsTable({required this.rows});

  static const double _minTableWidth = 620;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text('No student data yet',
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.slate400)),
        ),
      );
    }

    final table = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        ...rows.asMap().entries.map(
              (entry) => _StatsRow(
                stat: entry.value,
                isLast: entry.key == rows.length - 1,
              ),
            ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final content = ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffE2E8F0)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: table,
          ),
        );

        if (constraints.maxWidth < _minTableWidth) {
          return SingleChildScrollView(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(width: _minTableWidth, child: content),
              ),
            ),
          );
        }

        return SingleChildScrollView(child: content);
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xffF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xffE2E8F0))),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _HeaderCell('Student')),
          Expanded(flex: 2, child: _HeaderCell('Views')),
          Expanded(flex: 3, child: _HeaderCell('Progress')),
          Expanded(flex: 2, child: _HeaderCell('Last Watched')),
          Expanded(flex: 3, child: _HeaderCell('Entry Test')),
        ],
      ),
    );
  }
}

class _StatsRow extends StatefulWidget {
  final StudentLessonStat stat;
  final bool isLast;
  const _StatsRow({required this.stat, required this.isLast});

  @override
  State<_StatsRow> createState() => _StatsRowState();
}

class _StatsRowState extends State<_StatsRow> {
  bool hovered = false;

  /// Views like "5/5" can mean "watched every available time" which the
  /// reference design flags with a small warning — kept here since it's
  /// derivable from the real `views` string without inventing new fields.
  bool get _isMaxedOut {
    final parts = widget.stat.views.split('/');
    if (parts.length != 2) return false;
    final a = int.tryParse(parts[0].trim());
    final b = int.tryParse(parts[1].trim());
    return a != null && b != null && b > 0 && a >= b;
  }

  String _formatLastWatched(DateTime? dt) {
    if (dt == null) return '—';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0 && now.day == dt.day) return 'Today';
    if (diff.inDays == 1 ||
        (diff.inDays == 0 && now.day != dt.day)) {
      return 'Yesterday';
    }
    if (diff.inDays > 1 && diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('MMM d, y').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.stat;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hovered ? const Color(0xffFAFAFA) : Colors.white,
          border: widget.isLast
              ? null
              : const Border(bottom: BorderSide(color: Color(0xffF1F5F9))),
        ),
        child: Row(
          children: [
            // Student
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  s.studentName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0F172A),
                  ),
                ),
              ),
            ),

            // Views
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    s.views,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _isMaxedOut
                          ? const Color(0xffD97706)
                          : AppColors.slate600,
                    ),
                  ),
                  if (_isMaxedOut) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.warning_amber_rounded,
                        size: 14, color: Color(0xffD97706)),
                  ],
                ],
              ),
            ),

            // Progress
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: (s.progress / 100).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: const Color(0xffE5E7EB),
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${s.progress}%',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Last Watched
            Expanded(
              flex: 2,
              child: Text(
                _formatLastWatched(s.lastWatched),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.slate600,
                ),
              ),
            ),

            // Entry Test
            Expanded(
              flex: 3,
              child: _entryTestBadge(s.entryTest),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryTestBadge(EntryTestResult result) {
    late Color bg;
    late Color fg;
    late String label;

    switch (result.status) {
      case 'Passed':
        bg = const Color(0xffDCFCE7);
        fg = const Color(0xff16A34A);
        label = '✓ Passed';
        break;
      case 'Failed':
        bg = const Color(0xffFEE2E2);
        fg = const Color(0xffDC2626);
        label = '✕ Failed';
        break;
      case 'Pending':
        bg = const Color(0xffFEF3C7);
        fg = const Color(0xffD97706);
        label = '⏱ Pending';
        break;
      default:
        bg = const Color(0xffF1F5F9);
        fg = const Color(0xff64748B);
        label = 'N/A';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration:
              BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ),
        if (result.score != null) ...[
          const SizedBox(width: 6),
          Text(
            '(${result.score}%)',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.slate500,
            ),
          ),
        ],
      ],
    );
  }
}