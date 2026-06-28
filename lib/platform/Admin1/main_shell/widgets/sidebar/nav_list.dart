import 'package:flutter/material.dart';
import 'nav_item_model.dart';
import 'nav_tile.dart';

class NavList extends StatelessWidget {
  final int selectedIndex;
  final int? hoveredIndex;
  final double fadeValue;
  final void Function(int) onTap;
  final void Function(int) onHover;
  final VoidCallback onHoverExit;

  const NavList({
    super.key,
    required this.selectedIndex,
    required this.hoveredIndex,
    required this.fadeValue,
    required this.onTap,
    required this.onHover,
    required this.onHoverExit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      itemCount: kNavItems.length,
      itemBuilder: (_, i) => NavTile(
        item: kNavItems[i],
        isActive:  selectedIndex == i,
        isHovered: hoveredIndex == i && selectedIndex != i,
        fadeValue: fadeValue,
        onTap:   () => onTap(i),
        onEnter: () => onHover(i),
        onExit:  onHoverExit,
      ),
    );
  }
}