import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
Future<void> showLanguageSheet(BuildContext context, dynamic profile) async {
  final screenWidth = MediaQuery.of(context).size.width;
  final currentLang = context.locale.languageCode;

  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.05,
        horizontal: screenWidth * 0.04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Language'.tr(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          _LanguageOption(
            label: 'English',
            flag: '🇬🇧',
            isSelected: currentLang == 'en',
            onTap: () async {
              Navigator.pop(sheetContext);
              await context.setLocale(const Locale('en'));
             // Restart.restartApp();
            },
          ),
          SizedBox(height: screenWidth * 0.02),
          _LanguageOption(
            label: 'العربية',
            flag: '🇪🇬',
            isSelected: currentLang == 'ar',
            onTap: () async {
              Navigator.pop(sheetContext);
              await context.setLocale(const Locale('ar'));
              //Restart.restartApp();

            },
          ),
          SizedBox(height: screenWidth * 0.02),
        ],
      ),
    ),
  );
}

class _LanguageOption extends StatelessWidget {
  final String label, flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ListTile(
      onTap: onTap,
      leading: Text(flag, style: TextStyle(fontSize: screenWidth * 0.07)),
      title: Text(
        label,
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      tileColor: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
          : Colors.transparent,
    );
  }
}