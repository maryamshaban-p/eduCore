import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/session/cubit/session_upload_cubit.dart';
import 'package:edulink_app/students/features/session/data/session_repo.dart';
import 'package:edulink_app/students/features/session/widgets/custom_file_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadHomeworkScreen extends StatelessWidget {
  final int sessionId;
  final String courseName;
  final String lessonTitle;

  const UploadHomeworkScreen({
    super.key,
    required this.sessionId,
    required this.courseName,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionUploadCubit(SessionRepository(), sessionId)..loadHomeworkStatus(),
      child: _UploadHomeworkView(courseName: courseName, lessonTitle: lessonTitle),
    );
  }
}

class _UploadHomeworkView extends StatelessWidget {
  final String courseName;
  final String lessonTitle;

  const _UploadHomeworkView({required this.courseName, required this.lessonTitle});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF012D54)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          //const Icon(Icons.search_rounded, color: Color(0xFF012D54)),
          SizedBox(width: screenWidth * 0.03),
          const Icon(Icons.notifications, color: Color(0xFF012D54)),
          SizedBox(width: screenWidth * 0.04),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
          child: BlocConsumer<SessionUploadCubit, SessionUploadState>(
            listener: (context, state) {
              if (state is SessionUploadError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              final isUploading = state is SessionUploadUploading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Homework Card
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      border: Border.all(color: const Color(0xFFAAAAAD)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.red, size: screenWidth * 0.1),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Homework".tr(), style: TextStyle(color: const Color(0xFF5C5C5C), fontSize: screenWidth * 0.036)),
                              Text(lessonTitle, style: TextStyle(color: const Color(0xFF012D54), fontWeight: FontWeight.w600, fontSize: screenWidth * 0.042)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.025),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth * 0.11,
                        height: screenWidth * 0.11,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE5DFDF)),
                        ),
                        child: Icon(Icons.cloud_upload_outlined, color: const Color(0xFF5C5C5C), size: screenWidth * 0.05),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Upload files", style: TextStyle(fontSize: screenWidth * 0.044, fontWeight: FontWeight.w600, color: const Color(0xFF2C2C2C))),
                            SizedBox(height: screenHeight * 0.003),
                            Text("Select and upload the files of your choice",
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.034, color: const Color(0xFF616161))),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  GestureDetector(
                    onTap: isUploading ? null : () => context.read<SessionUploadCubit>().pickAndSubmitHomework(),
                    child: DottedBorderBox(
                      width: screenWidth,
                      height: screenHeight,
                      child: Column(
                        children: [
                          Icon(Icons.cloud_upload_outlined, size: screenWidth * 0.1, color: const Color(0xFF5C5C5C)),
                          SizedBox(height: screenHeight * 0.012),
                          Text("Choose a file or drag & drop it here.",
                              textAlign: TextAlign.center, style: TextStyle(fontSize: screenWidth * 0.038, fontWeight: FontWeight.bold)),
                          SizedBox(height: screenHeight * 0.004),
                          Text("JPEG, PNG, PDF, and MP4 formats, up to 50MB.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.032, color: const Color(0xFF616161))),
                          SizedBox(height: screenHeight * 0.012),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(screenWidth * 0.02),
                            ),
                            child: Text(
                              isUploading ? "Uploading..." : "Browse File",
                              style: TextStyle(fontSize: screenWidth * 0.036, fontWeight: FontWeight.bold, color: const Color(0xFF616161)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

            
                  if (isUploading)
                    CustomFileItem(
                      w: screenWidth,
                      h: screenHeight,
                      name: state.fileName,
                      progress: state.progress,
                      isCompleted: false,
                      sizeText: '${(state.sizeBytes / 1024).toStringAsFixed(0)} KB',
                    ),

                  if (state is SessionUploadLoaded && state.submission != null)
                    CustomFileItem(
                      w: screenWidth,
                      h: screenHeight,
                      name: state.submission!.fileName,
                      progress: 1.0,
                      isCompleted: true,
                    ),

                  if (state is SessionUploadLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  final double width, height;
  final Widget child;
  const DottedBorderBox({super.key, required this.width, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.03),
        border: Border.all(color: const Color(0xFFAAAAAD), style: BorderStyle.solid),
      ),
      child: child,
    );
  }
}