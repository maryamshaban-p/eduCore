// lib/students/shared_widgets/request_reason_dialog.dart
//
// Shared dialog used everywhere the student needs to submit a
// "view request" or a "retake request" with a reason, without
// leaving the current screen and without needing to know/remember
// the sessionId manually (it's always passed in by the caller).

import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/quiz/data/request_repo.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

enum RequestReasonType { views, retake }

/// Shows a small dialog with a text field for the reason and a submit
/// button that calls the repository directly (no extra navigation).
///
/// Returns `true` if the request was submitted successfully, `false`
/// if the user cancelled, and `null` if the dialog was dismissed some
/// other way.
Future<bool?> showRequestReasonDialog({
  required BuildContext context,
  required int sessionId,
  required RequestReasonType type,
  String? title,
  String? description,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => _RequestReasonDialog(
      sessionId: sessionId,
      type: type,
      title: title,
      description: description,
    ),
  );
}

class _RequestReasonDialog extends StatefulWidget {
  final int sessionId;
  final RequestReasonType type;
  final String? title;
  final String? description;

  const _RequestReasonDialog({
    required this.sessionId,
    required this.type,
    this.title,
    this.description,
  });

  @override
  State<_RequestReasonDialog> createState() => _RequestReasonDialogState();
}

class _RequestReasonDialogState extends State<_RequestReasonDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _repo = RequestRepository();
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isViews => widget.type == RequestReasonType.views;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final reason = _reasonController.text.trim();

    try {
      if (_isViews) {
        await _repo.submitViewRequest(widget.sessionId, reason);
      } else {
        await _repo.submitRetakeRequest(widget.sessionId, reason);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultTitle =
        _isViews ? 'Request More Views'.tr() : 'Request Retake'.tr();
    final defaultDescription = _isViews
        ? 'Explain why you need more views for this session.'.tr()
        : 'Explain why you need to retake this test.'.tr();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            _isViews ? Icons.videocam_outlined : Icons.replay_outlined,
            color: AppColors.primaryColor,
            size: 22,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(widget.title ?? defaultTitle,
                style: const TextStyle(fontSize: 17)),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description ?? defaultDescription,
              style: TextStyle(fontSize: 13, color: AppColors.greyColor),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _reasonController,
              autofocus: true,
              maxLines: 3,
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                hintText: 'Type your reason here...'.tr(),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.lightGray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.lightGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 1.5),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Reason is required'.tr();
                }
                if (v.trim().length < 5) {
                  return 'Please provide more detail'.tr();
                }
                return null;
              },
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12.5),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context, false),
          child: Text('Cancel'.tr(),
              style: TextStyle(color: AppColors.greyColor)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.2),
                )
              : Text('Submit'.tr(), style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

/// Shows a simple success snackbar after a request was submitted.
/// Call this after `showRequestReasonDialog` returns `true`.
void showRequestSubmittedSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Request submitted successfully!'.tr()),
      backgroundColor: AppColors.deepGreen,
    ),
  );
}