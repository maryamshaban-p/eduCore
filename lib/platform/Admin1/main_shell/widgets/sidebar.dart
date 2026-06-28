import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/platform/Admin1/features/logout/widgets/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'sidebar/collapse_toggle.dart';
import 'sidebar/nav_item_model.dart';
import 'sidebar/nav_list.dart';
import 'sidebar/sidebar_footer.dart';
import 'sidebar/sidebar_logo.dart';

export 'sidebar/nav_item_model.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onItemTap;
  const Sidebar({super.key, required this.selectedIndex, required this.onItemTap});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  bool _collapsed = false;
  int? _hoveredIndex;

  late final AnimationController _controller;
  late final Animation<double> _widthAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 220));
    _widthAnim = Tween<double>(begin: 260, end: 72).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeAnim = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _toggle(BuildContext context) {
    if (Breakpoints.isMobile(context)) {
      // على الموبايل: يقفل الـ Drawer
      Navigator.of(context).pop();
    } else {
      // على الديسكتوب: collapse عادي
      setState(() => _collapsed = !_collapsed);
      _collapsed ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => SizedBox(
        width: isMobile ? 260 : _widthAnim.value,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(color: AppColors.slateDark900),
          child: Column(children: [
            SidebarLogo(fadeValue: isMobile ? 1.0 : _fadeAnim.value),
            const Divider(color: Colors.white10, height: 1),
            Expanded(child: NavList(
              selectedIndex: widget.selectedIndex,
              hoveredIndex: _hoveredIndex,
              fadeValue: isMobile ? 1.0 : _fadeAnim.value,
              onTap: widget.onItemTap,
              onHover: (i) => setState(() => _hoveredIndex = i),
              onHoverExit: () => setState(() => _hoveredIndex = null),
            )),
            const Divider(color: Colors.white10, height: 1),
            SidebarFooter(
              collapsed: isMobile ? false : _collapsed,
              fadeValue: isMobile ? 1.0 : _fadeAnim.value,
              onLogout: () => LogoutDialog.show(context),
            ),
            CollapseToggle(
              // على الموبايل الأيقونة تتغير لـ X عشان يعرف إنه هيقفل
              collapsed: isMobile ? false : _collapsed,
              onTap: () => _toggle(context),
            ),
          ]),
        ),
      ),
    );
  }
}