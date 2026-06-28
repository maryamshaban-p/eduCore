import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/platform/landing_page/views/landing.dart';
import 'package:edulink_app/site/shared_widgets/custom_dashboard_item.dart';
import 'package:edulink_app/site/shared_widgets/custom_navbarItem.dart';
import 'package:flutter/material.dart';

class DashboardSidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTap;
  final double screenWidth;
  final List<SidebarItem> items;

  final String userName;
  final String userRole;
  final String userInitials;

  final bool forceCollapsed; // ← desktop collapse (جاي من الشاشة الأب)
  final VoidCallback? onToggleCollapse; // ← زرار القفل/الفتح تحت

  const DashboardSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
    required this.screenWidth,
    required this.items,
    required this.userName,
    required this.userRole,
    required this.userInitials,
    this.forceCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  State<DashboardSidebar> createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar> {
  int? _hoveredIndex;

  // المدة دي لازم تكون مطابقة لمدة الـ AnimatedContainer
  // في الشاشة الأب (ModratorDashboardScreen / TeacherDashboardScreen)
  static const _collapseDuration = Duration(milliseconds: 220);

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.slate800,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.slate600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Inter', color: AppColors.slate600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LandingPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final isCollapsed = !isMobile && widget.forceCollapsed;

    final h = MediaQuery.of(context).size.height;

    return Container(
      height: h,
      decoration: const BoxDecoration(color: AppColors.slateDark900),
      child: Column(
        children: [
          SizedBox(height: h * 0.02),

          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: isCollapsed
                ? Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary,
                      ),
                      child: const Icon(Icons.school_outlined,
                          color: Colors.white, size: 20),
                    ),
                  )
                : CustomNavbarItem(screenWidth: widget.screenWidth),
          ),

          SizedBox(height: h * 0.015),
          const Divider(color: Colors.white10, height: 1),
          SizedBox(height: h * 0.01),

          // Nav items
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: Custom_Dashboard_item(
                    isActive: widget.selectedIndex == index,
                    isHovered: _hoveredIndex == index,
                    screenWidth: widget.screenWidth,
                    icon: widget.items[index].icon,
                    labelName: widget.items[index].label,
                    isCollapsed: isCollapsed,
                    onTap: () {
                      widget.onItemTap(index);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // ───── User info (الاسم + initials) ─────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _CollapseAwareRow(
              collapsed: isCollapsed,
              duration: _collapseDuration,
              avatar: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: AppColors.primaryDark,
                ),
                child: Center(
                  child: Text(
                    widget.userInitials,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              expandedChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.userName.isEmpty ? 'User' : widget.userName,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.userRole.isEmpty ? 'moderator' : widget.userRole,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.slate400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // ───── Logout button ─────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _LogoutButton(
              collapsed: isCollapsed,
              duration: _collapseDuration,
              onTap: () => _showLogoutDialog(context),
            ),
          ),

          const SizedBox(height: 8),

          // ───── Collapse toggle ─────
          if (!isMobile)
            _CollapseToggle(
              collapsed: isCollapsed,
              onTap: widget.onToggleCollapse,
            ),

          SizedBox(height: h * 0.01),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// صف الـ avatar + معلومات اليوزر، بيتحكم في وقت ظهور
// واختفاء الجزء النصي بحيث يتزامن مع أنيميشن عرض الـ sidebar
// نفسه (مش بيظهر فورًا زي قبل كده).
// ─────────────────────────────────────────────────────────
class _CollapseAwareRow extends StatelessWidget {
  final bool collapsed;
  final Duration duration;
  final Widget avatar;
  final Widget expandedChild;

  const _CollapseAwareRow({
    required this.collapsed,
    required this.duration,
    required this.avatar,
    required this.expandedChild,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        avatar,
        // بدل ما النص يظهر فورًا، الـ AnimatedSize بيكبر/يصغر
        // تدريجيًا بنفس مدة أنيميشن عرض الـ sidebar في الشاشة الأب،
        // فمفيش لحظة يطلب فيها مساحة أكبر من المتاح فعليًا.
        ClipRect(
          child: AnimatedSize(
            duration: duration,
            curve: Curves.easeInOut,
            alignment: Alignment.centerLeft,
            child: collapsed
                ? const SizedBox(width: 0, height: 36)
                : Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      width: 150,
                      child: expandedChild,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// زرار القفل والفتح
// ─────────────────────────────────────────────────────────
class _CollapseToggle extends StatelessWidget {
  final bool collapsed;
  final VoidCallback? onTap;
  const _CollapseToggle({required this.collapsed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: double.infinity,
        color: Colors.white.withValues(alpha: 0.04),
        child: Center(
          child: Icon(
            collapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
            color: Colors.white38,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// زرار تسجيل الخروج — نفس مبدأ التزامن مع مدة الأنيميشن
// ─────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final bool collapsed;
  final Duration duration;
  final VoidCallback onTap;
  const _LogoutButton({
    required this.collapsed,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withValues(alpha: 0.05),
        ),
        child: Row(
          mainAxisAlignment:
              collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout_rounded, size: 18, color: Colors.white54),
            ClipRect(
              child: AnimatedSize(
                duration: duration,
                curve: Curves.easeInOut,
                alignment: Alignment.centerLeft,
                child: collapsed
                    ? const SizedBox(width: 0, height: 18)
                    : const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                          softWrap: false,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarItem {
  final String label;
  final IconData icon;
  const SidebarItem({required this.label, required this.icon});
}