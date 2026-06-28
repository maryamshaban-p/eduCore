import 'package:edulink_app/students/features/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showEditProfileDialog(
  BuildContext context,
  dynamic profile,
) async {
  final screenWidth = MediaQuery.of(context).size.width;

  final firstNameCtrl =
      TextEditingController(text: profile.firstName);

  final lastNameCtrl =
      TextEditingController(text: profile.lastName);

  final phoneCtrl =
      TextEditingController(text: profile.phone);

  String languagePref = profile.languagePref;

  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(screenWidth * 0.05),
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                  ),
                ),

                SizedBox(height: screenWidth * 0.03),

                TextField(
                  controller: lastNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                  ),
                ),

                SizedBox(height: screenWidth * 0.03),

                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                  ),
                ),

                SizedBox(height: screenWidth * 0.04),

                DropdownButtonFormField<String>(
                  value: languagePref,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text('Arabic'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        languagePref = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<ProfileCubit>().updateProfile(
                      firstName: firstNameCtrl.text,
                      lastName: lastNameCtrl.text,
                      phone: phoneCtrl.text,
                      languagePref: languagePref,
                    );
              },
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}