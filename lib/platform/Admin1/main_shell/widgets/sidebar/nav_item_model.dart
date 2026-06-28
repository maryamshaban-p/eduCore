import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;
  const NavItem({required this.icon, required this.label});
}

const kNavItems = [
  NavItem(icon: Icons.grid_view_rounded, label: 'Overview'),
  NavItem(icon: Icons.person_outline,    label: 'Teachers'),
  NavItem(icon: Icons.shield_outlined,   label: 'Moderators'),
  NavItem(icon: Icons.bar_chart_rounded, label: 'Reports'),
  NavItem(icon: Icons.settings_outlined, label: 'Settings'),
];
