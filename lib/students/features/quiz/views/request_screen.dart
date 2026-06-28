// lib/students/features/requests/views/requests_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/quiz/cubit/request_cubit.dart';
import 'package:edulink_app/students/features/quiz/cubit/request_state.dart';
import 'package:edulink_app/students/features/quiz/data/request_model.dart';
import 'package:edulink_app/students/features/quiz/data/request_repo.dart';
import 'package:edulink_app/utils/app_colors.dart';
import 'package:edulink_app/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsScreen extends StatelessWidget {
  /// Optional: pre-fill sessionId when coming from a specific session
  final int? sessionId;

  /// Optional: pre-select type when coming from a specific flow
  /// 'views' or 'retake'
  final String? preSelectedType;

  const RequestsScreen({
    super.key,
    this.sessionId,
    this.preSelectedType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestCubit(RequestRepository())..loadMyRequests(),
      child: _RequestsView(
        sessionId: sessionId,
        preSelectedType: preSelectedType,
      ),
    );
  }
}

class _RequestsView extends StatefulWidget {
  final int? sessionId;
  final String? preSelectedType;

  const _RequestsView({this.sessionId, this.preSelectedType});

  @override
  State<_RequestsView> createState() => _RequestsViewState();
}

class _RequestsViewState extends State<_RequestsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _sessionIdController = TextEditingController();
  String _selectedType = 'views';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.preSelectedType != null) {
      _selectedType = widget.preSelectedType!;
    }
    if (widget.sessionId != null) {
      _sessionIdController.text = widget.sessionId.toString();
      // Jump to submit tab if coming from a session
      _tabController.index = 0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reasonController.dispose();
    _sessionIdController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final sessionId = int.tryParse(_sessionIdController.text.trim());
    if (sessionId == null) return;

    final reason = _reasonController.text.trim();
    final cubit = context.read<RequestCubit>();

    if (_selectedType == 'views') {
      cubit.submitViewRequest(sessionId, reason);
    } else {
      cubit.submitRetakeRequest(sessionId, reason);
    }
  }

  Widget _buildCustomTabBar(double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.06,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AnimatedBuilder(
        animation: _tabController.animation!,
        builder: (context, _) {
          final selectedIndex = _tabController.index;
          return Row(
            children: [
              Expanded(
                child: _buildTabItem(
                  label: 'New Request'.tr(),
                  selected: selectedIndex == 0,
                  onTap: () => _tabController.animateTo(0),
                ),
              ),
              Expanded(
                child: _buildTabItem(
                  label: 'My Requests'.tr(),
                  selected: selectedIndex == 1,
                  onTap: () => _tabController.animateTo(1),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_outlined,
                        color: AppColors.lightBlueGray),
                  ),
                  SizedBox(width: screenWidth * 0.15),
                  Text('My Requests'.tr(),
                      style: AppStyles.lightBlueGray35
                          .copyWith(fontSize: 22)),
                ],
              ),
            ),

            // ── Tab Bar ─────────────────────────────────────────────────
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: _buildCustomTabBar(screenWidth, screenHeight),
            ),

            SizedBox(height: screenHeight * 0.02),

            // ── Tab Views ────────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<RequestCubit, RequestState>(
                listener: (context, state) {
                  if (state is RequestSubmitSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Request submitted successfully!'.tr()),
                        backgroundColor: AppColors.deepGreen,
                      ),
                    );
                    _reasonController.clear();
                    if (widget.sessionId == null) {
                      _sessionIdController.clear();
                    }
                    // Reload requests list and switch to it
                    context.read<RequestCubit>().loadMyRequests();
                    _tabController.animateTo(1);
                  }
                  if (state is RequestError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // ── Tab 1: Submit Request ──────────────────────────
                      _buildSubmitTab(
                          context, state, screenWidth, screenHeight),

                      // ── Tab 2: My Requests ─────────────────────────────
                      _buildRequestsList(
                          context, state, screenWidth, screenHeight),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitTab(BuildContext context, RequestState state,
      double screenWidth, double screenHeight) {
    final isSubmitting = state is RequestSubmitting;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.02),

            // Request Type Selector
            Text('Request Type'.tr(),
                style: AppStyles.coalGray12
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 15)),
            SizedBox(height: screenHeight * 0.012),
            Row(
              children: [
                _TypeChip(
                  label: 'View Request'.tr(),
                  icon: Icons.play_circle_outline,
                  selected: _selectedType == 'views',
                  onTap: () => setState(() => _selectedType = 'views'),
                ),
                SizedBox(width: screenWidth * 0.03),
                _TypeChip(
                  label: 'Retake Test'.tr(),
                  icon: Icons.quiz_outlined,
                  selected: _selectedType == 'retake',
                  onTap: () => setState(() => _selectedType = 'retake'),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.025),

            // Session ID field (hidden if pre-filled)
            if (widget.sessionId == null) ...[
              Text('Session ID'.tr(),
                  style: AppStyles.coalGray12.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              SizedBox(height: screenHeight * 0.008),
              TextFormField(
                controller: _sessionIdController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                    'Enter session ID'.tr(), Icons.numbers_outlined),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Session ID is required'.tr();
                  }
                  if (int.tryParse(v.trim()) == null) {
                    return 'Enter a valid number'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
            ] else ...[
              // Show the pre-filled session as a badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.012),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: AppColors.primaryColor, size: 18),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      '${'Session'.tr()} ID:${widget.sessionId}',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],

            // Reason field
            Text('Reason'.tr(),
                style: AppStyles.coalGray12
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 15)),
            SizedBox(height: screenHeight * 0.008),
            TextFormField(
              controller: _reasonController,
              maxLines: 4,
              decoration: _inputDecoration(
                  'Explain why you need this request...'.tr(),
                  Icons.edit_note_outlined),
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

            SizedBox(height: screenHeight * 0.035),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed:
                    isSubmitting ? null : () => _submit(context),
                child: isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text('Submit Request'.tr(),
                        style: AppStyles.whiteColor16),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(BuildContext context, RequestState state,
      double screenWidth, double screenHeight) {
    if (state is RequestLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RequestError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: screenHeight * 0.015),
            Text(state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
            SizedBox(height: screenHeight * 0.02),
            TextButton(
              onPressed: () =>
                  context.read<RequestCubit>().loadMyRequests(),
              child: Text('Retry'.tr()),
            ),
          ],
        ),
      );
    }

    if (state is RequestLoaded) {
      if (state.requests.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined,
                  size: 64, color: AppColors.greyColor),
              SizedBox(height: screenHeight * 0.015),
              Text('No requests yet'.tr(),
                  style: AppStyles.coalGray
                      .copyWith(fontSize: 16)),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () =>
            context.read<RequestCubit>().loadMyRequests(),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.01),
          itemCount: state.requests.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: screenHeight * 0.012),
          itemBuilder: (_, i) =>
              _RequestCard(request: state.requests[i]),
        ),
      );
    }

    // While submitting, keep showing the last loaded list or empty
    return const SizedBox();
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.greyColor),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}

// ── Type Chip ───────────────────────────────────────────────────────────────
class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.primaryColor
                : AppColors.lightGray,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18,
                color: selected ? Colors.white : AppColors.greyColor),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.greyColor,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Request Card ─────────────────────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final StudentRequest request;
  const _RequestCard({required this.request});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.deepGreen;
      case 'rejected':
        return AppColors.deepRed;
      default:
        return Colors.orange.shade700;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_top_rounded;
    }
  }

  String _typeLabel(String type) {
    return type == 'test' ? 'Retake Test' : 'View Request';
  }

  IconData _typeIcon(String type) {
    return type == 'test' ? Icons.quiz_outlined : Icons.play_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_typeIcon(request.type),
                  color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _typeLabel(request.type).tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(request.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon(request.status),
                        size: 13,
                        color: _statusColor(request.status)),
                    const SizedBox(width: 4),
                    Text(
                      request.status.tr(),
                      style: TextStyle(
                        color: _statusColor(request.status),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request.sessionTitle,
            style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            request.reason,
            style: TextStyle(color: AppColors.greyColor, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(request.createdAt),
            style: TextStyle(color: AppColors.greyColor, fontSize: 11),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year}  '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}