import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:flutter/material.dart';
import 'contact/contact_buttons.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final isMobile = c.maxWidth < 700;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight,
              colors: [AppColors.backgroundLight, AppColors.backgroundDark]),
        ),
        child: Column(children: [
          Text('Contact Us', textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: isMobile ? 28 : 38,
                  fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 560),
            child: Text('Subscribe to EduCore now and step into the future of education.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Inter', fontSize: isMobile ? 16 : 18,
                    color: AppColors.slate200, height: 1.7)),
          ),
          const SizedBox(height: 40),
          const ContactButtons(),
        ]),
      );
    });
  }
}
