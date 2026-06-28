import 'package:flutter/material.dart';

class AppConfig {
  static const String baseUrl = 'http://localhost:5132';

  static String resolveUrl(String url) {
    if (url.isEmpty) return url;
    return url.startsWith('http') ? url : '$baseUrl$url';
  }
}

class CourseImageWidget extends StatelessWidget {
  final String? pictureUrl;
  const CourseImageWidget({super.key, this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final fullUrl = pictureUrl != null ? AppConfig.resolveUrl(pictureUrl!) : null;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: screenHeight * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            child: fullUrl != null
                ? Image.network(
                    fullUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/Women_teacher.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset('assets/images/Women_teacher.jpg', fit: BoxFit.cover),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: const Icon(Icons.play_arrow_rounded, size: 40),
            ),
          ),
        ),
      ],
    );
  }
}