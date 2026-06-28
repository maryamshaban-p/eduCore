import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FileItem extends StatelessWidget {
  final Map<String, dynamic> file;
  final VoidCallback onDelete;

  const FileItem({
    super.key,
    required this.file,
    required this.onDelete,
  });

  Widget _getFileIcon(String fileName) {
    final String ext = fileName.split('.').last.toLowerCase();

    switch (ext) {
      case 'pdf':
        return Image.asset(
          'assets/images/pdf_image.png',
          width: 42,
          height: 52,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.picture_as_pdf,
            color: Colors.red,
            size: 48,
          ),
        );
      case 'jpg':
      case 'jpeg':
      case 'png':
        return const Icon(Icons.image, color: Colors.orange, size: 48);
      case 'mp4':
      case 'mov':
        return const Icon(Icons.video_library, color: Colors.purple, size: 48);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: Colors.blue, size: 48);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey, size: 48);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUploading = file['uploading'] ?? false;
    final double progress = (file['progress'] ?? 0.0).toDouble();
    final String name = file['name'] ?? 'Unknown file';
    final String size = file['size'] ?? '0 KB';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
       color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getFileIcon(name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C2C),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      size,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(width: 12),
                    isUploading ? SizedBox(width: 14,height: 14,child: CircularProgressIndicator(color:Color(0xFF3D8FEF),strokeWidth: 2.5 ,)) :Icon( Icons.check_circle,size: 20,color: const Color(0xFF4FAE90),),
                    Text(
                      isUploading ? " Uploading...".tr() : " Completed".tr(),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: 
                            const Color(0xFF757575)
 
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (isUploading)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2196F3),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (isUploading)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.close, color: Color(0xFF9E9E9E), size: 24),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_forever_outlined,
               
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}