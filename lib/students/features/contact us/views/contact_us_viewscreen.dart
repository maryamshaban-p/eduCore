import 'package:edulink_app/students/features/contact%20us/widgets/contact_infosection.dart';
import 'package:edulink_app/students/features/contact%20us/widgets/send_messageSection.dart';
import 'package:flutter/material.dart';
import '../widgets/header_section.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .05,
            vertical: screenHeight * .015,
          ),
          child: Column(
            children: [
              const HeaderSection(),

              SizedBox(height: screenHeight * .03),

              const ContactInfoSection(),

              SizedBox(height: screenHeight * .03),

              const SendMessageSection(),

              SizedBox(height: screenHeight * .04),
            ],
          ),
        ),
      ),
    );
  }
}