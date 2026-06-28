
import 'package:edulink_app/students/features/subject/data/subject_model.dart';
import 'package:flutter/material.dart';

class FileCard extends StatelessWidget {
  final SessionFile file;
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTap;

  const FileCard({
    required this.file,
    required this.screenWidth,
    required this.screenHeight,
    required this.onTap,
  });

  IconData _getIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'mp4': case 'mov': return Icons.video_library;
      case 'jpg': case 'jpeg': case 'png': return Icons.image;
      default: return Icons.insert_drive_file;
    }
  }

  Color _getColor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf': return Colors.red;
      case 'mp4': case 'mov': return Colors.purple;
      case 'jpg': case 'jpeg': case 'png': return Colors.orange;
      default: return Colors.blueGrey;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
        padding: EdgeInsets.all(screenWidth * 0.035),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: [
            Icon(_getIcon(file.fileType), color: _getColor(file.fileType), size: screenWidth * 0.09),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(file.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: screenWidth * 0.038, fontWeight: FontWeight.w500)),
                  Text(_formatSize(file.fileSize),
                      style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.open_in_new_rounded, size: 20, color: Color(0xFF055092)),
          ],
        ),
      ),
    );
  }
}