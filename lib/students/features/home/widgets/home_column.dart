import 'package:flutter/material.dart';

class HomeColumn extends StatelessWidget {
  const HomeColumn({
    super.key,
    required this.firstColor,
    required this.secoundColor,
    required this.iconData,
    required this.title, required this.onTap,
  });
  final Color firstColor, secoundColor;
  final IconData iconData;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [firstColor, secoundColor]),
                shape: BoxShape.circle),
            child: Icon(
              size: 35,
              iconData,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF7F838B),
                fontSize: 14),
          )
        ],
      ),
    );
  }
}