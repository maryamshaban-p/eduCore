import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'input_field.dart';
import 'section_title.dart';

class SendMessageSection extends StatefulWidget {
  const SendMessageSection({super.key});

  @override
  State<SendMessageSection> createState() => _SendMessageSectionState();
}

class _SendMessageSectionState extends State<SendMessageSection> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required".tr();
    }

    if (value.trim().length < 3) {
      return "Enter a valid name".tr();
    }

    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required".tr();
    }

    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return "Enter a valid phone number".tr();
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required".tr();
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(value)) {
      return "Enter a valid email".tr();
    }

    return null;
  }

  String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Message is required".tr();
    }

    if (value.trim().length < 10) {
      return "Message is too short".tr();
    }

    return null;
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text("Message sent successfully".tr()),
        ),
      );

      fullNameController.clear();
      phoneController.clear();
      emailController.clear();
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(w * .05),
      decoration: BoxDecoration(
         color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(w * .05),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
             Align(
              alignment: Alignment.centerLeft,
              child: SectionTitle(
                title: "SEND A MESSAGE".tr(),
              ),
            ),

            CustomInputField(
              controller: fullNameController,
              label: "Full Name".tr(),
              hint: "Enter your full name".tr(),
              icon: Icons.person_outline,
              validator: validateName,
            ),

            SizedBox(height: h * .022),

            CustomInputField(
              controller: phoneController,
              label: "Phone Number".tr(),
              hint: "Enter your phone number".tr(),
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: validatePhone,
            ),

            SizedBox(height: h * .022),

            CustomInputField(
              controller: emailController,
              label: "Email Address".tr(),
              hint: "Enter your email".tr(),
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
            ),

            SizedBox(height: h * .022),

            CustomInputField(
              controller: messageController,
              label: "Your Message".tr(),
              hint: "Tell us what you need help with...".tr(),
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: validateMessage,
            ),

            SizedBox(height: h * .03),

            SizedBox(
              width: double.infinity,
              height: h * .07,
              child: ElevatedButton.icon(
                onPressed: submitForm,
                icon: const Icon(Icons.send_rounded),
                label: Text(
                  "Send Message".tr(),
                  style: TextStyle(
                    fontSize: w * .042,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff204593),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * .04),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}