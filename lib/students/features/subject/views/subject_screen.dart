import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/lesson/views/lesson_view_screen.dart';
import 'package:edulink_app/students/features/subject/cubit/subject_cubit.dart';
import 'package:edulink_app/students/features/subject/data/subject_repo.dart';
import 'package:edulink_app/students/features/subject/views/summarize_screen.dart';
import 'package:edulink_app/students/features/subject/widgets/custom_lessonItem.dart';
import 'package:edulink_app/students/features/subject/widgets/custom_top_card.dart';
import 'package:edulink_app/students/shared_widgets/custom_bottom_navigationBar.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubjectCubit(SubjectRepository())..loadSubjects(),
      child: const _SubjectView(),
    );
  }
}

class _SubjectView extends StatelessWidget {
  const _SubjectView();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isTablet = screenWidth >= 600;
    final horizontalPadding = isTablet ? screenWidth * 0.08 : screenWidth * 0.05;
    final titleFontSize = isTablet ? screenWidth * 0.04 : screenWidth * 0.06;
    final sectionFontSize = isTablet ? screenWidth * 0.03 : screenWidth * 0.045;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // ── Header ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subject'.tr(),
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      size: (screenWidth * 0.06).clamp(22.0, 32.0),
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 24,
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // ── Top Cards ────────────────────────────────────────────
              // Single card taking full width.
              // Add more Expanded siblings here when the Test card is ready.
              Row(
                children: [
                  Expanded(
                    child: CustomTopCard(
                      h: screenHeight,
                      w: screenWidth,
                      title: 'Summarize'.tr(),
                      subtitle: 'Study notes'.tr(),
                      color: AppColors.blueColor,
                      icon: Icons.auto_stories_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SummarizePdfScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),// ── Section label ────────────────────────────────────────
              Text(
                'My Lessons'.tr(),
                style: TextStyle(
                  fontSize: sectionFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // ── Lessons list ─────────────────────────────────────────
              Expanded(
                child: BlocBuilder<SubjectCubit, SubjectState>(
                  builder: (context, state) {
                    if (state is SubjectLoading || state is SubjectInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SubjectError) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                size: (screenWidth * 0.12).clamp(40.0, 64.0),
                                color: AppColors.greyColor,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red.shade400,
                                  fontSize: (screenWidth * 0.038).clamp(12.0, 16.0),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              TextButton.icon(
                                onPressed: () =>
                                    context.read<SubjectCubit>().loadSubjects(),
                                icon: const Icon(Icons.refresh_rounded),
                                label: Text('Retry'.tr()),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is SubjectLoaded) {
                      if (state.subjects.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                size: (screenWidth * 0.14).clamp(48.0, 72.0),
                                color: AppColors.greyColor.withOpacity(0.5),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                'No subjects enrolled yet'.tr(),
                                style: TextStyle(
                                  color: AppColors.greyColor,
                                  fontSize: (screenWidth * 0.04).clamp(13.0, 16.0),
                                ),
                              ),
                            ],
                          ),
                        );
                      }return RefreshIndicator(
                        onRefresh: () =>
                            context.read<SubjectCubit>().loadSubjects(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: state.subjects.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: screenHeight * 0.012),
                          itemBuilder: (context, index) {
                            final subject = state.subjects[index];
                            return custom_lessonItem(
                              w: screenWidth,
                              h: screenHeight,
                              title: subject.title,
                              teacher: subject.teacherName,
                              progressPercent: subject.progressPercent,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LessonViewScreen(
                                      courseId: subject.courseId,
                                      courseTitle: subject.title,
                                      teacherSubject: subject.teacherSubject,
                                    ),
                                  ),
                                ).then((_) {
                                  if (context.mounted) {
                                    context
                                        .read<SubjectCubit>()
                                        .loadSubjects();
                                  }
                                });
                              },
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        selectedIndex: 1,
      ),
    );
  }
}