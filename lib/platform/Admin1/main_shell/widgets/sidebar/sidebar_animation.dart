/*import 'package:flutter/material.dart';

/// يجمع الـ AnimationController والـ animations الخاصة بالـ Sidebar
class SidebarAnimation {
  late final AnimationController controller;
  late final Animation<double> width;
  late final Animation<double> fade;

  void init(TickerProvider vsync) {
    controller = AnimationController(vsync: vsync, duration: const Duration(milliseconds: 220));
    width = Tween<double>(begin: 260, end: 72).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    fade = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: controller,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
  }

  void forward() => controller.forward();
  void reverse() => controller.reverse();
  void dispose() => controller.dispose();
}
*/