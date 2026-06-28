import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/platform/Admin1/core/widgets/panel_header.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/cubit/teachers_cubit.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/data/teacher_model.dart';
import 'package:edulink_app/platform/Admin1/features/teachers/widgets/panel/teacher_panel_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherPanel extends StatefulWidget {
  final TeacherModel? teacher;
  final VoidCallback onClose;

  const TeacherPanel({super.key, this.teacher, required this.onClose});

  @override
  State<TeacherPanel> createState() => _TeacherPanelState();
}

class _TeacherPanelState extends State<TeacherPanel> {
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confCtrl    = TextEditingController();
  bool _obscurePass  = true;
  bool _obscureConf  = true;

  bool get _isEdit => widget.teacher != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _nameCtrl.text    = widget.teacher?.name    ?? '';
      _emailCtrl.text   = widget.teacher?.email   ?? '';
      _subjectCtrl.text = widget.teacher?.subject ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _passCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<TeachersCubit>();

    final nameParts = _nameCtrl.text.trim().split(' ');
    final firstname = nameParts.first;
    final lastname  = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    if (_isEdit) {
      cubit.updateTeacher(
        teacherId: widget.teacher!.id,
        firstname: firstname,
        lastname:  lastname,
        email:     _emailCtrl.text,
        subject:   _subjectCtrl.text,
      );
    } else {
      cubit.addTeacher(
        firstname:       firstname,
        lastname:        lastname,
        email:           _emailCtrl.text,
        password:        _passCtrl.text,
        passwordConfirm: _confCtrl.text,
        subject:         _subjectCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: panelWidth(context),
      height: double.infinity,
      color: Colors.white,
      child: Column(children: [
        PanelHeader(
          title: _isEdit ? 'Edit Teacher' : 'Add Teacher',
          onClose: widget.onClose,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: BlocBuilder<TeachersCubit, TeachersState>(
                builder: (context, state) {
                  final isLoading = state is TeachersLoaded && state.isSubmitting;
                  return TeacherPanelForm(
                    nameCtrl:    _nameCtrl,
                    emailCtrl:   _emailCtrl,
                    subjectCtrl: _subjectCtrl,
                    passCtrl:    _passCtrl,
                    confCtrl:    _confCtrl,
                    obscurePass: _obscurePass,
                    obscureConf: _obscureConf,
                    isEdit:      _isEdit,
                    isLoading:   isLoading,
                    onTogglePass: () => setState(() => _obscurePass = !_obscurePass),
                    onToggleConf: () => setState(() => _obscureConf = !_obscureConf),
                    onSubmit:    _submit,
                  );
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}