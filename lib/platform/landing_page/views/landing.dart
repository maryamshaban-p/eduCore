import 'package:edulink_app/platform/landing_page/widgets/landing_widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'landing_body.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollCtrl  = ScrollController();
  final _featuresKey = GlobalKey();
  final _aboutKey    = GlobalKey();
  final _contactKey  = GlobalKey();

  @override
  void dispose() { _scrollCtrl.dispose(); super.dispose(); }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final scrollRO = Scrollable.of(ctx).context.findRenderObject();
    final offset = box.localToGlobal(Offset.zero, ancestor: scrollRO).dy;
    _scrollCtrl.animateTo(
      (_scrollCtrl.offset + offset).clamp(
          _scrollCtrl.position.minScrollExtent,
          _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(
        onFeaturesTap: () => _scrollTo(_featuresKey),
        onAboutTap:    () => _scrollTo(_aboutKey),
        onFaqTap:      () => _scrollTo(_contactKey),
      ),
      body: LandingBody(
        scrollCtrl:  _scrollCtrl,
        featuresKey: _featuresKey,
        aboutKey:    _aboutKey,
        contactKey:  _contactKey,
      ),
    );
  }
}
