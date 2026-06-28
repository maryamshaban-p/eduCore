import 'package:edulink_app/platform/landing_page/widgets/landing_widgets/about_section.dart';
import 'package:edulink_app/platform/landing_page/widgets/landing_widgets/contact_section.dart';
import 'package:edulink_app/platform/landing_page/widgets/landing_widgets/features_section.dart';
import 'package:edulink_app/platform/landing_page/widgets/landing_widgets/footer_widget.dart';
import 'package:edulink_app/platform/landing_page/widgets/landing_widgets/hero_section.dart';
import 'package:edulink_app/platform/landing_page/widgets/landing_widgets/stats_section.dart';
import 'package:flutter/material.dart';

class LandingBody extends StatelessWidget {
  final ScrollController scrollCtrl;
  final GlobalKey featuresKey, aboutKey, contactKey;
  const LandingBody({super.key, required this.scrollCtrl,
      required this.featuresKey, required this.aboutKey, required this.contactKey});

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(const Color(0xFFCBD5E1)),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(8),
        thickness: WidgetStateProperty.all(6),
      ),
      child: SingleChildScrollView(
        controller: scrollCtrl,
        child: Column(children: [
          const HeroSection(),
          FeaturesSection(key: featuresKey),
          const StatsSection(),
          AboutSection(key: aboutKey),
          ContactSection(key: contactKey),
          const FooterWidget(),
        ]),
      ),
    );
  }
}
