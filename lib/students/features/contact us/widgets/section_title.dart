import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        bottom: w * .04,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: w * .033,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w800,
          color: const Color(0xff204593),
        ),
      ),
    );
  }
}