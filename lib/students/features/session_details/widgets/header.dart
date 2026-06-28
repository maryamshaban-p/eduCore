import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
        const Spacer(),
       // const Icon(Icons.search_rounded, color: Color(0xFF012D54)),
        const SizedBox(width: 10),
        const Icon(Icons.notifications, color: Color(0xFF012D54)),
      ],
    );
  }
}