import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/Messages/cubit/unread_messages_cubit.dart';
import 'package:edulink_app/students/features/home/cubit/home_cubit.dart';
import 'package:edulink_app/students/features/home/data/home_repo.dart';
import 'package:edulink_app/students/features/home/widgets/header.dart';
import 'package:edulink_app/students/features/home/widgets/lesson_card.dart';
import 'package:edulink_app/students/features/home/widgets/performance_overview_card.dart';
import 'package:edulink_app/students/features/home/widgets/statistics_card.dart';
import 'package:edulink_app/students/features/lesson/views/lesson_view_screen.dart';
import 'package:edulink_app/students/features/subject/views/subject_screen.dart';
import 'package:edulink_app/students/shared_widgets/custom_bottom_navigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewScreen extends StatelessWidget {
  const HomeViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(HomeRepository())..loadHome(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  void initState() {
    super.initState();
    // Home is the first screen a logged-in student lands on, so this
    // is where we know we're authenticated as a student and it's
    // safe to start checking for unread moderator messages.
    context.read<UnreadMessagesCubit>().startPolling();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is HomeError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }
        if (state is HomeLoaded) {
          final data = state.data;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(studentName: data.studentName),
                    const SizedBox(height: 24),

                    StatisticsCard(
                      statistics: data.statistics,
                      academicLevel: data.academicLevel,
                    ),
                    const SizedBox(height: 16),

                    PerformanceOverviewCard(),
                    const SizedBox(height: 28),

                    // ── Section header ──────────────────────────────
                    Row(
                      children: [
                        Text(
                          'Last Lessons'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const Spacer(),
                        if (data.recentCourses.isNotEmpty)
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SubjectScreen()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFF3D8FEF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'See All'.tr(),
                                style: const TextStyle(
                                  color: Color(0xFF3D8FEF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Lessons list ────────────────────────────────
                    data.recentCourses.isEmpty
                        ? _EmptyLessonsCard(
                            onExplore: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SubjectScreen()),
                            ),
                          )
                        : SizedBox(
                            height: isTablet ? 240 : 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              itemCount: data.recentCourses.length,
                              itemBuilder: (context, i) {
                                final course = data.recentCourses[i];
                                const baseUrl = 'http://localhost:5000';
                                final imageUrl = course.pictureUrl != null
                                    ? (course.pictureUrl!.startsWith('http')
                                        ? course.pictureUrl!
                                        : '$baseUrl${course.pictureUrl}')
                                    : null;
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: i < data.recentCourses.length - 1
                                          ? 12
                                          : 0),
                                  child: LessonsCard(
                                    imageUrl: imageUrl ??
                                        'assets/images/home_figure1.png',
                                    title: course.title,
                                    time: course.teacherName,
                                    isNetworkImage: imageUrl != null,
                                    cardWidth: isTablet ? 200 : 160,
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => LessonViewScreen(
                                          courseId: course.courseId,
                                          courseTitle: course.title,
                                          teacherSubject: course.teacherName,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(
              screenHeight: size.height,
              screenWidth: size.width,
              selectedIndex: 0,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

/// Empty state for "Last Lessons" — shown only when the student has no
/// enrolled courses yet. Replaces the previous static placeholder cards.
class _EmptyLessonsCard extends StatelessWidget {
  final VoidCallback onExplore;

  const _EmptyLessonsCard({required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF3D8FEF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              color: Color(0xFF3D8FEF),
              size: 28,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'no_lessons_yet_title'.tr(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'no_lessons_yet_message'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF3D8FEF),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: onExplore,
            child: Text('explore_subjects'.tr()),
          ),
        ],
      ),
    );
  }
}
