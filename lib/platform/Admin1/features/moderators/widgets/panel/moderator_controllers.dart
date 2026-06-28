import 'package:flutter/material.dart';
import '../../data/moderator_model.dart';

class ModeratorControllers {
  final name  = TextEditingController();
  final email = TextEditingController();
  final pass  = TextEditingController();
  final conf  = TextEditingController();

  void init(ModeratorModel? moderator) {
    name.text  = moderator?.name  ?? '';
    email.text = moderator?.email ?? '';
  }

  void dispose() {
    name.dispose(); email.dispose();
    pass.dispose(); conf.dispose();
  }
}