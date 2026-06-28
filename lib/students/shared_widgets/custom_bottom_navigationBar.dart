import 'package:edulink_app/students/features/Messages/cubit/unread_messages_cubit.dart';
import 'package:edulink_app/students/features/home/views/home_view_screen.dart';
import 'package:edulink_app/students/features/Messages/views/message_viewscreen.dart';
import 'package:edulink_app/students/features/profile/views/my_profile_view_screen.dart';
import 'package:edulink_app/students/features/subject/views/subject_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.selectedIndex,
  });

  final double screenHeight;
  final double screenWidth;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenHeight * 0.012,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(screenWidth * 0.08),
        ),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            ontap: selectedIndex == 0
                ? null
                : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const HomeViewScreen(),
                      ),
                    );
                  },
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: "Home",
            isActive: selectedIndex == 0,
            screenWidth: screenWidth,
          ),

          _NavItem(
            ontap: selectedIndex == 1
                ? null
                : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SubjectScreen(),
                      ),
                    );
                  },
            icon: Icons.grid_view_rounded,
            activeIcon: Icons.grid_view_rounded,
            label: "Subject",
            isActive: selectedIndex == 1,
            screenWidth: screenWidth,
          ),

          BlocBuilder<UnreadMessagesCubit, int>(
            builder: (context, unreadCount) {
              return _NavItem(
                ontap: selectedIndex == 2
                    ? null
                    : () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const MessageScreen(),
                          ),
                        );
                      },
                icon: Icons.message_outlined,
                activeIcon: Icons.message_rounded,
                label: "Message",
                isActive: selectedIndex == 2,
                screenWidth: screenWidth,
                badgeCount: unreadCount,
              );
            },
          ),

          _NavItem(
            ontap: selectedIndex == 3
                ? null
                : () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const MyProfileViewScreen(),
                      ),
                    );
                  },
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: "My Profile",
            isActive: selectedIndex == 3,
            screenWidth: screenWidth,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback? ontap;
  final double screenWidth;
  final int badgeCount;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.ontap,
    required this.screenWidth,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF3D8FEF);

    final inactiveColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade500
        : Colors.grey.shade600;

    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenWidth * 0.018,
        ),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? activeColor : inactiveColor,
                  size: screenWidth * 0.065,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: screenWidth * 0.042,
                      ),
                      height: screenWidth * 0.042,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE24B4A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).cardColor,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        badgeCount > 9 ? '9+' : '$badgeCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.024,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: screenWidth * 0.008),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
