/*import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/shared_widgets/custom_textField.dart';
import 'package:flutter/material.dart';

class AddStudentStep1 extends StatelessWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController parentPhone;
  final String? selectedLevel;
  final TextEditingController year;
  final ValueChanged<String?> onLevelChanged;

  const AddStudentStep1({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.parentPhone,
    required this.selectedLevel,
    required this.year,
    required this.onLevelChanged,
  });

  static const List<String> _levels = ['Primary', 'Preparatory', 'Secondary'];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.slate800),
        ),
        SizedBox(height: screenHeight * 0.025),

        // Full Name
        const Text('Full Name *', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
        SizedBox(height: screenHeight * 0.01),
        custom_textField(controller: firstName, hintText: 'First Name'),
        SizedBox(height: 8),
        custom_textField(controller: lastName, hintText: 'Last Name'),

        SizedBox(height: screenHeight * 0.025),

        // Email
        const Text('Email *', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
        SizedBox(height: screenHeight * 0.01),
        custom_textField(controller: email, hintText: 'student@example.com'),

        SizedBox(height: screenHeight * 0.025),

        // Phone
        const Text('Phone Number', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
        SizedBox(height: screenHeight * 0.01),
        custom_textField(controller: phone, hintText: '+20 10...'),

        SizedBox(height: screenHeight * 0.025),

        // Academic Level
        const Text('Academic Level *', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
        SizedBox(height: screenHeight * 0.01),
        _LevelDropdown(
          selected: selectedLevel,
          onChanged: onLevelChanged,
          levels: _levels,
        ),

        SizedBox(height: screenHeight * 0.025),

        // Academic Year
        const Text('Academic Year *', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
        SizedBox(height: screenHeight * 0.01),
        custom_textField(controller: year, hintText: 'e.g. 1'),

        SizedBox(height: screenHeight * 0.025),

        // Parent Phone
        const Text('Parent Phone Number', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400)),
        SizedBox(height: screenHeight * 0.01),
        custom_textField(controller: parentPhone, hintText: '+20 ...'),

        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }
}

class _LevelDropdown extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onChanged;
  final List<String> levels;

  const _LevelDropdown({required this.selected, required this.onChanged, required this.levels});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.slate200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          isExpanded: true,
          hint: const Text('Select level', style: TextStyle(color: AppColors.slate400)),
          items: levels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}*/