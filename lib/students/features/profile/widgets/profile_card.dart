import 'dart:typed_data';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edulink_app/students/features/profile/cubit/profile_cubit.dart';
import 'info_badge.dart';

class ProfileCard extends StatelessWidget {
  final String initials;
  final String fullName;
  final String email;
  final String academicLevel;
  final int classLevel;
  final String? imageUrl;
  final bool isUploadingPhoto;

  const ProfileCard({
    super.key,
    required this.initials,
    required this.fullName,
    required this.email,
    required this.academicLevel,
    required this.classLevel,
    this.imageUrl,
    this.isUploadingPhoto = false,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (context.mounted) {
      context.read<ProfileCubit>().uploadPhoto(bytes, picked.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.06,
            horizontal: screenWidth * 0.04,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.16,
                    backgroundColor: const Color(0xFFEEEDFE),
                    backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                        ? NetworkImage(imageUrl!)
                        : null,
                    child: (imageUrl == null || imageUrl!.isEmpty)
                        ? Text(
                            initials,
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF534AB7),
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: -screenWidth * 0.01,
                    child: GestureDetector(
                      onTap: isUploadingPhoto ? null : () => _pickImage(context),
                      child: Container(
                        width: screenWidth * 0.09,
                        height: screenWidth * 0.09,
                          decoration: BoxDecoration(
                      color: const Color(0xFF378ADD),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.whiteColor, width: 2.5),
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.white,
                      size: screenWidth * 0.045,
                    ),
                      ),
                    ),
                  ),
                ],
              ),

              if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                SizedBox(height: screenWidth * 0.02),
                TextButton.icon(
                  onPressed: isUploadingPhoto
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Photo'),
                              content: const Text(
                                  'Are you sure you want to delete your profile photo?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<ProfileCubit>()
                                        .deletePhoto();
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                  icon: Icon(Icons.delete_outline_rounded,
                      color: Colors.red.shade400, size: screenWidth * 0.04),
                  label: Text('Remove Photo',
                      style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: screenWidth * 0.032)),
                ),
              ] else
                SizedBox(height: screenWidth * 0.03),

              SizedBox(height: screenWidth * 0.02),
              Text(fullName,
                  style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: screenWidth * 0.01),
              Text(email,
                  style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: const Color(0xFF989898))),
              SizedBox(height: screenWidth * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoBadge(
                      label: academicLevel,
                      bg: const Color(0xFFE1F5EE),
                      fg: const Color(0xFF085041)),
                  SizedBox(width: screenWidth * 0.02),
                  InfoBadge(
                      label: "Class $classLevel",
                      bg: const Color(0xFFFAEEDA),
                      fg: const Color(0xFF854F0B)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}