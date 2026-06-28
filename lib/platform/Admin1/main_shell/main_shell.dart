import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/platform/Admin1/features/moderators/widgets/body/moderators_body.dart';
import 'package:edulink_app/platform/Admin1/features/overview/widgets/overview_body.dart';
import 'package:edulink_app/platform/Admin1/features/reports/widgets/reports_body.dart';
import 'package:edulink_app/platform/Admin1/features/settings/widgets/setting_body.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/widgets/body/teachers_body.dart';
import 'package:edulink_app/platform/Admin1/main_shell/widgets/dashboard_appbar.dart';
import 'package:edulink_app/platform/Admin1/main_shell/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const _titles = ['Overview', 'Teachers', 'Moderators', 'Reports', 'Settings'];
  static const _pages  = <Widget>[
    OverviewBody(), TeachersBody(), ModeratorsBody(), ReportsBody(), SettingsBody(),
  ];

  void _onTap(int i) {
    setState(() => _selectedIndex = i);
    if (Breakpoints.isMobile(context)) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Breakpoints.isMobile(context)
        ? _MobileLayout(selectedIndex: _selectedIndex, titles: _titles, pages: _pages, onTap: _onTap)
        : _DesktopLayout(selectedIndex: _selectedIndex, titles: _titles, pages: _pages, onTap: _onTap);
  }
}

class _DesktopLayout extends StatelessWidget {
  final int selectedIndex;
  final List<String> titles;
  final List<Widget> pages;
  final void Function(int) onTap;
  const _DesktopLayout({required this.selectedIndex, required this.titles, required this.pages, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(children: [
        Sidebar(selectedIndex: selectedIndex, onItemTap: onTap),
        Expanded(child: Column(children: [
          DashboardAppBar(title: titles[selectedIndex]),
          Expanded(child: pages[selectedIndex]),
        ])),
      ]),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final List<String> titles;
  final List<Widget> pages;
  final void Function(int) onTap;
  const _MobileLayout({required this.selectedIndex, required this.titles, required this.pages, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: Drawer(
        width: 260,
        child: Sidebar(
          selectedIndex: selectedIndex,
          onItemTap: onTap,
         // isInDrawer: true, // ← هنا التغيير
        ),
      ),
      appBar: DashboardAppBar(title: titles[selectedIndex]),
      body: pages[selectedIndex],
    );
  }
}