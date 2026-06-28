import 'dart:async';

import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_chat_model.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_message.dart';
import 'package:edulink_app/site/shared_widgets/app_snackbar.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:flutter/material.dart';

/// A small floating chat box for messaging a single student, meant to be
/// shown as an overlay on top of another screen (e.g. the student profile)
/// rather than navigating to a full Messages page.
///
/// Usage: wrap whatever screen should show it in a Stack, and conditionally
/// include this widget positioned in a corner — see StudentInformation for
/// an example.
class FloatingChatWidget extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String studentInitials;
  final VoidCallback onClose;

  const FloatingChatWidget({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.studentInitials,
    required this.onClose,
  });

  @override
  State<FloatingChatWidget> createState() => _FloatingChatWidgetState();
}

class _FloatingChatWidgetState extends State<FloatingChatWidget> {
  final ModeratorMessageService _service = ModeratorMessageService();

  List<ModeratorChatMessage> _messages = [];
  bool _isLoading = true;
  String? _error;

  final _composerController = TextEditingController();
  bool _isSending = false;
  final _scrollController = ScrollController();

  static const _pollInterval = Duration(seconds: 5);
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadConversation();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _silentRefresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await _service.getConversation(widget.studentId);
      if (!mounted) return;
      setState(() {
        _messages = data;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  Future<void> _silentRefresh() async {
    if (!mounted) return;
    try {
      final data = await _service.getConversation(widget.studentId);
      if (!mounted) return;
      if (data.length != _messages.length) {
        setState(() => _messages = data);
        _scrollToBottom();
      }
    } catch (_) {
      // Stay silent — retry on the next tick.
    }
  }

  Future<void> _send() async {
    final content = _composerController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _composerController.clear();

    try {
      final sent = await _service.sendMessage(
        studentId: widget.studentId,
        content: content,
      );
      if (!mounted) return;
      setState(() => _messages = [..._messages, sent]);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, friendlyErrorMessage(e));
      }
      _composerController.text = content;
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 340,
        height: 450,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.slate200),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildMessagesArea()),
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
            alignment: Alignment.center,
            child: Text(
              widget.studentInitials,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.studentName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: const Padding(
              padding: EdgeInsets.all(2),
              child: Icon(Icons.close_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesArea() {
    return Container(
      color: AppColors.slate50,
      child: LoadingErrorView(
        isLoading: _isLoading,
        error: _error,
        onRetry: _loadConversation,
        compact: true,
        builder: (context) {
          if (_messages.isEmpty) {
            return const EmptyStateView(
              icon: Icons.chat_bubble_outline_rounded,
              message: 'No messages yet. Say hello!',
            );
          }
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
          );
        },
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.slate200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _composerController,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate800),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Type a message...',
                hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: AppColors.slate50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.slate200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.slate200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isSending ? null : _send,
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(17)),
              alignment: Alignment.center,
              child: _isSending
                  ? const SizedBox(
                      width: 14, height: 14,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ModeratorChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isFromModerator;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 230),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: Radius.circular(isMine ? 10 : 2),
            bottomRight: Radius.circular(isMine ? 2 : 10),
          ),
          border: isMine ? null : Border.all(color: AppColors.slate200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontFamily: 'Inter', fontSize: 12,
                color: isMine ? Colors.white : AppColors.slate800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              message.timeAgo,
              style: TextStyle(
                fontFamily: 'Inter', fontSize: 9,
                color: isMine ? Colors.white70 : AppColors.slate400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}