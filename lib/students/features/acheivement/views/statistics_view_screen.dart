import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/acheivement/cubit/achievement_cubit.dart';
import 'package:edulink_app/students/features/acheivement/data/achievement_repo.dart';
import 'package:edulink_app/students/features/acheivement/widgets/achievment_card.dart';
import 'package:edulink_app/students/features/acheivement/widgets/achivement_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsViewScreen extends StatelessWidget {
  const StatisticsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AchievementCubit(AchievementRepository())..loadAchievement(),
      child: const _StatisticsView(),
    );
  }
}

class _StatisticsView extends StatelessWidget {
  const _StatisticsView();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
final isDark =  Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon:const Icon(Icons.arrow_back_rounded)),
        title:  Text('Course Achievement'.tr()),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
  color: Theme.of(context).cardColor,
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(44),
    topRight: Radius.circular(44),
  ),
),
          child: BlocBuilder<AchievementCubit, AchievementState>(
            builder: (context, state) {
              if (state is AchievementLoading || state is AchievementInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AchievementError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(state.message,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center),
                  ),
                );
              }
              if (state is AchievementLoaded) {
                final data = state.data;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      screenWidth >= 500
                          ? SizedBox(
                              height: 150,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  AchievmentCard(
                                    title: "Time Spend".tr(),
                                    subtitle: "${data.totalEnrolled} Course",
                                    color: const Color(0xFFE5E5FF),
                                    icon: Icons.watch_later_outlined,
                                    textColor: const Color(0xFF8A8A9F),
                                  ),
                                  const SizedBox(width: 12),
                                  AchievmentCard(
                                    title: "Completed".tr(),
                                    subtitle: "${data.completedCourses} Course",
                                    color: const Color(0xFFE6F3E9),
                                    icon: Icons.done_all_rounded,
                                    textColor: const Color(0xFF92A195),
                                  ),
                                  const SizedBox(width: 12),
                                  AchievmentCard(
                                    title: "Absences".tr(),
                                    subtitle: "${data.totalAbsences}",
                                    color: const Color(0xFFFCDDCB),
                                    icon: Icons.event_busy_outlined,
                                    textColor: const Color(0xFFA48E81),
                                  ),
                                  const SizedBox(width: 12),
                                  AchievmentCard(
                                    title: "Exam Result".tr(),
                                    subtitle: "${data.averageQuizScore}%",
                                    color: const Color(0xFFE9ECF3),
                                    icon: Icons.task,
                                    textColor: const Color(0xFFA5A9B3),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    AchievmentCard(
                                      title: "Time Spend".tr(),
                                      subtitle: "${data.totalEnrolled} Course",
                                      color:  const Color(0xFFE5E5FF),
                                      icon: Icons.watch_later_outlined,
                                      textColor: const Color(0xFF8A8A9F),
                                    ),
                                    const SizedBox(width: 12),
                                    AchievmentCard(
                                      title: "Completed".tr(),
                                      subtitle: "${data.completedCourses} Course",
                                      color:  const Color(0xFFE6F3E9),
                                      icon: Icons.done_all_rounded,
                                      textColor: const Color(0xFF92A195),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    AchievmentCard(
                                      title: "Absences".tr(),
                                      subtitle: "${data.totalAbsences}",
                                      color:  const Color(0xFFFCDDCB),
                                      icon: Icons.event_busy_outlined,
                                      textColor: const Color(0xFFA48E81),
                                    ),
                                    const SizedBox(width: 12),
                                    AchievmentCard(
                                      title: "Exam Result".tr(),
                                      subtitle: "${data.averageQuizScore}%",
                                      color:const Color(0xFFE9ECF3),
                                      icon: Icons.task,
                                      textColor: const Color(0xFFA5A9B3),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(height: 18),
                       Text(
                        'Courses Activity'.tr(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,                  ),
                      ),
                      const SizedBox(height: 12),
                      if (data.coursesActivity.isEmpty)
                         Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text(
                              'No courses enrolled yet'.tr(),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
                            ),
                          ),
                        )
                      else
                        ...data.coursesActivity.map((course) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AchievementListTile(
                                title: course.title,
                                url: 'assets/images/achive1.jpg',
                                subTitle: course.teacherName,
                                percentage: course.progressPercent.toDouble(),
                              ),
                            )),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}