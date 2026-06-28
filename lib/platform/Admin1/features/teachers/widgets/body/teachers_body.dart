import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/body_widgets.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/cubit/teachers_cubit.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/data/teachers_repo.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/widgets/panel/teachers_panel.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/widgets/table/teachers_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TeachersBody extends StatelessWidget {
  const TeachersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeachersCubit(TeachersRepository())..loadTeachers(),
      child: const _TeachersView(),
    );
  }
}

class _TeachersView extends StatelessWidget {
  const _TeachersView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeachersCubit, TeachersState>(
      listener: (context, state) {
        if (state is TeachersSuccess) {
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
        if (state is TeachersError) {
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
        if (state is TeachersLoading || state is TeachersInitial)
          return const Center(child: CircularProgressIndicator());
        if (state is TeachersLoaded) return _TeachersContent(state: state);
        return const SizedBox();
      },
    );
  }
}

class _TeachersContent extends StatelessWidget {
  final TeachersLoaded state;
  const _TeachersContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TeachersCubit>();
    return Stack(children: [
      SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SectionHeader(title: 'Teachers', buttonLabel: 'Add Teacher', onAdd: cubit.openAdd),
          const SizedBox(height: 20),
          TeachersTable(teachers: state.teachers, onEdit: cubit.openEdit),
        ]),
      ),
      if (state.panelOpen) ...[
        PanelOverlay(onTap: cubit.closePanel),
        SlidePanel(child: TeacherPanel(
          teacher: state.selectedTeacher,
          onClose: cubit.closePanel,
        )),
      ],
    ]);
  }
}