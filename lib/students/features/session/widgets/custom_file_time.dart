import 'package:flutter/material.dart';

class CustomFileItem extends StatelessWidget {
  const CustomFileItem({
    super.key,
    required this.w,
    required this.h,
    required this.name,
    required this.progress,
    required this.isCompleted,
    this.sizeText,
  });

  final double w;
  final double h;
  final String name;
  final double progress;
  final bool isCompleted;
  final String? sizeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
         color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.picture_as_pdf, color: Colors.red, size: w * 0.1),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: w * 0.038, fontWeight: FontWeight.w500)),
                SizedBox(height: h * 0.006),
                Row(
                  children: [
                    if (sizeText != null) Text(sizeText!, style: TextStyle(fontSize: w * 0.032, color: const Color(0xFF757575))),
                    SizedBox(width: w * 0.02),
                    isCompleted
                        ? Icon(Icons.check_circle, size: w * 0.045, color: const Color(0xFF4FAE90))
                        : SizedBox(width: w * 0.035, height: w * 0.035,
                            child: const CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF3D8FEF))),
                    SizedBox(width: w * 0.01),
                    Text(isCompleted ? "Completed" : "Uploading...", style: TextStyle(fontSize: w * 0.032, color: const Color(0xFF757575))),
                  ],
                ),
                if (!isCompleted) ...[
                  SizedBox(height: h * 0.008),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}