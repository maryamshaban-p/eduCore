import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/landing_page/cubit/login_cubit.dart';
import 'package:edulink_app/platform/landing_page/widgets/login_widgets/role_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kRoles = ['Institution Admin', 'Moderator', 'Teacher'];

class RoleSection extends StatelessWidget {
  const RoleSection({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Select Your Role',
              style: TextStyle(fontFamily: 'Inter', fontSize: 15,
                  fontWeight: FontWeight.w600, color: AppColors.slate800)),
          const SizedBox(height: 12),
          RoleSelector(
            roles:        kRoles,
            selectedRole: state.selectedRole,
            hoveredRole:  state.hoveredRole,
            onRoleTap:    cubit.selectRole,
            onRoleHover:  cubit.hoverRole,
            onRoleExit:   cubit.clearHover,
          ),
        ]);
      },
    );
  }
}
