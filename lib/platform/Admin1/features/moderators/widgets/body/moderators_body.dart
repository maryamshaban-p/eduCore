import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/body_widgets.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/checkbox/teacher_option.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/cubit/moderators_cubit.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/data/moderators_repo.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/widgets/panel/moderators_panel.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/widgets/table/moderators_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ModeratorsBody extends StatelessWidget {
  const ModeratorsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModeratorsCubit(ModeratorsRepository())..loadModerators(),
      child: const _ModeratorsView(),
    );
  }
}

class _ModeratorsView extends StatelessWidget {
  const _ModeratorsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModeratorsCubit, ModeratorsState>(
      listener: (context, state) {
        if (state is ModeratorsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
        if (state is ModeratorsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ModeratorsLoading || state is ModeratorsInitial)
          return const Center(child: CircularProgressIndicator());
        if (state is ModeratorsLoaded) return _ModeratorsContent(state: state);
        return const SizedBox();
      },
    );
  }
}

class _ModeratorsContent extends StatelessWidget {
  final ModeratorsLoaded state;
  const _ModeratorsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ModeratorsCubit>();

    final teacherOptions = state.availableTeachers.map((t) => TeacherOption(
      id: t.id,
      name: t.name,
      subject: t.subject,
    )).toList();

    return Stack(children: [
      SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(title: 'Moderators', buttonLabel: 'Add Moderator', onAdd: cubit.openAdd),
          const SizedBox(height: 20),
          ModeratorsTable(moderators: state.moderators, onEdit: cubit.openEdit),
        ]),
      ),
      if (state.panelOpen) ...[
        PanelOverlay(onTap: cubit.closePanel),
        SlidePanel(child: ModeratorPanel(
          moderator: state.selectedModerator,
          teachers: teacherOptions,
          onClose: cubit.closePanel,
        )),
      ],
    ]);
  }
}