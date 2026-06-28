import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'file_item.dart';

class UploadSection extends StatelessWidget {
  final List<Map<String, dynamic>> files;
  final Function(Map<String, dynamic>) addFile;
  final Function(int, double) updateFile;
  final Function(int) finishUpload;
  final Function(int) removeFile;
  final VoidCallback onClose;

  const UploadSection({
    super.key,
    required this.files,
    required this.addFile,
    required this.updateFile,
    required this.finishUpload,
    required this.removeFile,
    required this.onClose,
  });

  Future<void> pickFile() async {
    final result = await FilePicker.pickFiles();

    if (result != null) {
      final file = result.files.first;
      final sizeInKB = (file.size / 1024).toStringAsFixed(0);

      addFile({
        "name": file.name,
        "size": "$sizeInKB KB",
        "progress": 0.0,
        "uploading": true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
       color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xFF012D54),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFAAAAAD)),
            ),
            child: ListTile(
              leading: Image.asset('assets/images/pdf_image.png'),
              title:  Text(
                'Homework'.tr(),
                style: TextStyle(color: Color(0xFF5C5C5C), fontSize: 16),
              ),
              subtitle: const Text(
                'Introduction to Geometry',
                style: TextStyle(color: Color(0xFF012D54), fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Upload files section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5DFDF)),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF5C5C5C),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    Text(
                      "Upload files".tr(),
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Select and upload the files of your choice".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF616161),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(12),
            dashPattern: [5, 7],
            strokeCap: StrokeCap.round,
            color: const Color(0xFFAAAAAD),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined,
                      size: 40, color: Color(0xFF5C5C5C)),
                  const SizedBox(height: 10),
                   Column(
                    children: [
                      Text(
                        "Choose a file or drag & drop it here.".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "JPEG, PNG, PDF, and MP4 formats, up to 50MB.".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFF616161),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: pickFile,
                    child:  Text(
                      "Browse File".tr(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF616161),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // الملفات المرفوعة
          ...List.generate(files.length, (index) {
            return FileItem(
              file: files[index],
              onDelete: () => removeFile(index),
            );
          }),
        ],
      ),
    );
  }
}