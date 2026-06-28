import 'package:flutter/material.dart';

class CourseHeaderWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String title;
  final String image;

  const CourseHeaderWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back, size: screenWidth * 0.07),
            Row(
              children: [
                Icon(Icons.search, size: screenWidth * 0.07),
                SizedBox(width: screenWidth * 0.04),
                Icon(Icons.notifications, size: screenWidth * 0.07),
              ],
            )
          ],
        ),

        SizedBox(height: screenHeight * 0.02),

        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color(0xFF055092),
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        Container(
          width: double.infinity,
          height: screenHeight * 0.28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: screenWidth * 0.1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}