import 'package:flutter/material.dart';

class SlidePanel extends StatelessWidget {
  final Widget child;
  const SlidePanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, right: 0, bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0x18000000), blurRadius: 24, offset: Offset(-4, 0))]),
        child: child,
      ),
    );
  }
}
