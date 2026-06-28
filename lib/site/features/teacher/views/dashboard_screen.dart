import 'package:edulink_app/core/services/auth_service.dart';
import 'package:edulink_app/core/services/user_session.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/site/features/teacher/views/grades_screen.dart';
import 'package:edulink_app/site/features/teacher/views/mycourses_screen.dart';
import 'package:edulink_app/site/features/teacher/views/overview_screen.dart';
import 'package:edulink_app/site/features/teacher/views/requests_screen.dart';
import 'package:edulink_app/site/features/teacher/views/students_screens.dart';
import 'package:edulink_app/site/shared_widgets/custom_dashboard_sliderbar.dart';
import 'package:edulink_app/site/shared_widgets/custom_topbar_item.dart';
import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<TeacherDashboardScreen> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;

  bool _isLoading = true;
  String? _error;

  static final _pages = [
    TeacherOverviewScreen(),
    MycoursesScreen(),
    MyStudentsScreen(),
    //GradesScreen(),
    RequestsScreen(),
  ];

  static const _titles = [
    'Overview',
    'My Courses',
    'Students',
    //'Grades',
    'Requests'
  ];

  static const _items = [
    SidebarItem(label: 'Overview', icon: Icons.dashboard_outlined),
    SidebarItem(label: 'My Courses', icon: Icons.menu_book_outlined),
    SidebarItem(label: 'Students', icon: Icons.people_alt_outlined),
   // SidebarItem(label: 'Grades', icon: Icons.bar_chart_rounded),
    SidebarItem(label: 'Requests', icon: Icons.notifications_none_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// 🔥 IMPORTANT: الاسم + role من /auth/me
  Future<void> _loadUser() async {
    try {
      await _authService.getMe();

      setState(() {
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    final sw = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(context);

    final sidebar = DashboardSidebar(
      screenWidth: sw,
      selectedIndex: _selectedIndex,
      onItemTap: (i) => setState(() => _selectedIndex = i),
      items: _items,
      forceCollapsed: _sidebarCollapsed,
      userName: UserSession.fullName,
      userRole: UserSession.role,
      userInitials: UserSession.getInitials(UserSession.fullName),
      onToggleCollapse: () {
        setState(() => _sidebarCollapsed = !_sidebarCollapsed);
      },
    );

    // ───────────────── MOBILE ─────────────────
    if (isMobile) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        drawer: Drawer(width: 240, child: sidebar),
        appBar: CustomTopbarItem(
          pageName: _titles[_selectedIndex],
          userName:
              UserSession.fullName.isEmpty ? 'User' : UserSession.fullName,
          userInitials: UserSession.getInitials(UserSession.fullName),
          showMenuButton: true,
        ),
        body: _pages[_selectedIndex],
      );
    }

    // ───────────────── DESKTOP ─────────────────
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            width: _sidebarCollapsed ? 70 : 240,
            child: sidebar,
          ),

          Expanded(
            child: Column(
              children: [
                CustomTopbarItem(
                  pageName: _titles[_selectedIndex],
                  userName: UserSession.fullName.isEmpty
                      ? 'User'
                      : UserSession.fullName,
                  userInitials: UserSession.getInitials(UserSession.fullName),
                ),

                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}