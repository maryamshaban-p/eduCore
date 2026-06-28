import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'contact_card.dart';
import 'section_title.dart';

class ContactInfoSection extends StatelessWidget {
  const ContactInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: "CONTACT INFORMATION".tr(),
        ),

        ContactCard(
          icon: Icons.phone_outlined,
          title: "+1 (800) 555-0199",
          subtitle: "Student Support".tr(),
        ),

        ContactCard(
          icon: Icons.phone_outlined,
          title: "+1 (800) 555-0177",
          subtitle: "Technical Support".tr(),
        ),

        ContactCard(
          icon: Icons.email_outlined,
          title: "hello@eduapp.io",
          subtitle: "General Inquiries".tr(),
        ),

        ContactCard(
          icon: Icons.email_outlined,
          title: "support@eduapp.io",
          subtitle: "Course & Account Support".tr(),
        ),
      ],
    );
  }
}