import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/core/services/auth_service.dart';
import 'package:edulink_app/core/services/user_session.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/site/features/modrator/views/activity_screen.dart';
import 'package:edulink_app/site/features/modrator/views/enrollments_screen.dart';
import 'package:edulink_app/site/features/modrator/views/overview_screen.dart';
import 'package:edulink_app/site/features/modrator/views/students_screen.dart';
import 'package:edulink_app/site/shared_widgets/custom_dashboard_sliderbar.dart';
import 'package:edulink_app/site/shared_widgets/custom_topbar_item.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:flutter/material.dart';

class ModratorDashboardScreen extends StatefulWidget {
  const ModratorDashboardScreen({super.key});

  @override
  State<ModratorDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<ModratorDashboardScreen> {
  final AuthService _authService = AuthService();

  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;

  bool _isLoading = true;
  String? _error;

  static const _pages = [
    ModratorOverviewScreen(),
    StudentsScreen(),
    EnrollmentsScreen(),
    ActivityScreen(),
  ];

  static const _titles = [
    'Overview',
    'Students',
    'Enrollments',
    'Activity',
  ];

  static const _items = [
    SidebarItem(label: 'Overview', icon: Icons.dashboard_outlined),
    SidebarItem(label: 'Students', icon: Icons.people_alt_outlined),
    SidebarItem(label: 'Enrollments', icon: Icons.link),
    SidebarItem(label: 'Activity', icon: Icons.monitor_heart_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// 🔥 unified identity source
  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await _authService.getMe();
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Full-screen loading / error state (before the shell is ready).
    if (_isLoading || _error != null) {
      return Scaffold(
        body: LoadingErrorView(
          isLoading: _isLoading,
          error: _error,
          onRetry: _loadUser,
          builder: (_) => const SizedBox.shrink(),
        ),
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

    // ───────────── MOBILE ─────────────
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

    // ───────────── DESKTOP ─────────────
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