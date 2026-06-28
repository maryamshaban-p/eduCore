import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final List<String> roles;
  final int selectedRole;
  final int? hoveredRole;
  final void Function(int) onRoleTap, onRoleHover;
  final VoidCallback onRoleExit;

  const RoleSelector({super.key, required this.roles, required this.selectedRole,
      required this.hoveredRole, required this.onRoleTap,
      required this.onRoleHover, required this.onRoleExit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(roles.length, (i) => Expanded(
              child: _RoleTile(
                label: roles[i],
                isActive:  selectedRole == i,
                isHovered: hoveredRole == i && selectedRole != i,
                onTap:    () => onRoleTap(i),
                onEnter:  () => onRoleHover(i),
                onExit:   onRoleExit,
              ))),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final String label;
  final bool isActive, isHovered;
  final VoidCallback onTap, onEnter, onExit;
  const _RoleTile({required this.label, required this.isActive,
      required this.isHovered, required this.onTap,
      required this.onEnter, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter(),
      onExit:  (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(label, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'Inter', fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? Colors.white
                        : isHovered ? AppColors.slate700 : AppColors.slate400)),
          ),
        ),
      ),
    );
  }
}
