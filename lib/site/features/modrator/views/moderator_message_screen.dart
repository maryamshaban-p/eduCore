import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/core/errors/api_exception.dart';
import 'package:edulink_app/core/theme/app_theam.dart';
import 'package:edulink_app/platform/Admin1/core/utils/responsive.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_chat_model.dart';
import 'package:edulink_app/site/features/modrator/services/moderator_message.dart';
import 'package:edulink_app/site/shared_widgets/app_snackbar.dart';
import 'package:edulink_app/site/shared_widgets/loading_error_view.dart';
import 'package:flutter/material.dart';

class ModeratorMessagesScreen extends StatefulWidget {
  const ModeratorMessagesScreen({super.key});

  @override
  State<ModeratorMessagesScreen> createState() => _ModeratorMessagesScreenState();
}

class _ModeratorMessagesScreenState extends State<ModeratorMessagesScreen> {
  final ModeratorMessageService _service = ModeratorMessageService();

  List<ModeratorContact> _contacts = [];
  bool _loadingContacts = true;
  String? _contactsError;

  ModeratorContact? _selectedContact;
  List<ModeratorChatMessage> _messages = [];
  bool _loadingMessages = false;
  String? _messagesError;

  final _composerController = TextEditingController();
  bool _isSending = false;

  final _scrollController = ScrollController();

  // Polling: re-fetch contacts (and the open conversation, if any) every
  // few seconds so new messages show up without needing a manual reload.
  // This is a simple stand-in for real-time updates (e.g. SignalR) — good
  // enough for now, can be swapped out later without touching the UI code.
  static const _pollInterval = Duration(seconds: 5);
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _silentRefresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _composerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _loadingContacts = true;
      _contactsError = null;
    });
    try {
      final data = await _service.getContacts();
      if (!mounted) return;
      setState(() {
        _contacts = data;
        _loadingContacts = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _contactsError = friendlyErrorMessage(e);
        _loadingContacts = false;
      });
    }
  }

  /// Called on every poll tick. Refreshes the contacts list and, if a
  /// conversation is open, refreshes its messages too — all without
  /// touching the loading/error flags, so the UI doesn't flash a spinner
  /// or interrupt someone mid-scroll or mid-typing.
  Future<void> _silentRefresh() async {
    if (!mounted) return;

    try {
      final contacts = await _service.getContacts();
      if (!mounted) return;
      setState(() => _contacts = contacts);

      // Keep _selectedContact's data (like unreadCount) in sync with the
      // refreshed list, in case it changed (e.g. after the student reads
      // the message we just sent, or sends a new one).
      if (_selectedContact != null) {
        final updated = contacts.where((c) => c.studentId == _selectedContact!.studentId);
        if (updated.isNotEmpty) {
          _selectedContact = updated.first;
        }
      }
    } catch (_) {
      // Silent on purpose — a single failed poll shouldn't show an error;
      // it'll just retry on the next tick.
    }

    if (_selectedContact != null) {
      try {
        final messages = await _service.getConversation(_selectedContact!.studentId);
        if (!mounted) return;
        // Only update + re-scroll if the message count actually changed,
        // so we're not fighting the user's current scroll position every
        // 5 seconds for no reason.
        if (messages.length != _messages.length) {
          setState(() => _messages = messages);
          _scrollToBottom();
        }
      } catch (_) {
        // Same as above — stay silent, just retry next tick.
      }
    }
  }

  Future<void> _selectContact(ModeratorContact contact) async {
    setState(() {
      _selectedContact = contact;
      _loadingMessages = true;
      _messagesError = null;
      _messages = [];
    });
    try {
      final data = await _service.getConversation(contact.studentId);
      if (!mounted) return;
      setState(() {
        _messages = data;
        _loadingMessages = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messagesError = friendlyErrorMessage(e);
        _loadingMessages = false;
      });
    }
  }

  Future<void> _send() async {
    final content = _composerController.text.trim();
    if (content.isEmpty || _selectedContact == null || _isSending) return;

    setState(() => _isSending = true);
    _composerController.clear();

    try {
      final sent = await _service.sendMessage(
        studentId: _selectedContact!.studentId,
        content: content,
      );
      if (!mounted) return;
      setState(() => _messages = [..._messages, sent]);
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, friendlyErrorMessage(e));
      // Put the text back so the moderator doesn't lose what they typed.
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
    final isMobile = Breakpoints.isMobile(context);

    if (isMobile) {
      // On small screens, show only one pane at a time: the contacts list
      // until something is selected, then the conversation full-width with
      // a back button to return to the list.
      return _selectedContact == null
          ? _buildContactsList()
          : _buildConversation(showBackButton: true);
    }

    return Row(
      children: [
        // ── Left: contacts list ──────────────────────────────────────
        Container(
          width: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: AppColors.slate200)),
          ),
          child: _buildContactsList(),
        ),

        // ── Right: conversation ──────────────────────────────────────
        Expanded(
          child: _selectedContact == null
              ? _buildEmptyState()
              : _buildConversation(),
        ),
      ],
    );
  }

  Widget _buildContactsList() {
    return LoadingErrorView(
      isLoading: _loadingContacts,
      error: _contactsError,
      onRetry: _loadContacts,
      builder: (context) {
        if (_contacts.isEmpty) {
          return  EmptyStateView(
            icon: Icons.chat_bubble_outline_rounded,
            message: 'No conversations yet.'.tr(),
          );
        }

        return ListView.builder(
          itemCount: _contacts.length,
          itemBuilder: (context, index) {
            final c = _contacts[index];
            final isSelected = _selectedContact?.studentId == c.studentId;
            final hasUnread = c.unreadCount > 0;

            return InkWell(
              onTap: () => _selectContact(c),
              child: Container(
                color: isSelected ? AppColors.primaryXL : Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.slate100,
                        borderRadius: BorderRadius.circular(21),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        c.avatarInitials,
                        style: TextStyle(
                          fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : AppColors.slate600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  c.fullName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Inter', fontSize: 13,
                                    fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                                    color: AppColors.slate800,
                                  ),
                                ),
                              ),
                              Text(
                                c.timeAgo,
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppColors.slate400),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  c.lastMessage,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Inter', fontSize: 12,
                                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                                    color: hasUnread ? AppColors.slate700 : AppColors.slate500,
                                  ),
                                ),
                              ),
                              if (hasUnread) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${c.unreadCount}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const EmptyStateView(
      icon: Icons.chat_bubble_outline_rounded,
      message: 'Select a conversation to start chatting',
    );
  }

  Widget _buildConversation({bool showBackButton = false}) {
    final contact = _selectedContact!;
    return Column(
      children: [
        // ── Header ──────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.slate200)),
          ),
          child: Row(
            children: [
              if (showBackButton) ...[
                GestureDetector(
                  onTap: () => setState(() => _selectedContact = null),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.arrow_back_rounded, color: AppColors.slate600, size: 20),
                  ),
                ),
              ],
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(18)),
                alignment: Alignment.center,
                child: Text(
                  contact.avatarInitials,
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.slate600),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                contact.fullName,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate800),
              ),
            ],
          ),
        ),

        // ── Messages ────────────────────────────────────────────────
        Expanded(child: _buildMessagesArea()),

        // ── Composer ────────────────────────────────────────────────
        _buildComposer(),
      ],
    );
  }

  Widget _buildMessagesArea() {
    return Container(
      color: AppColors.slate50,
      child: LoadingErrorView(
        isLoading: _loadingMessages,
        error: _messagesError,
        onRetry: () => _selectContact(_selectedContact!),
        builder: (context) {
          if (_messages.isEmpty) {
            return const EmptyStateView(
              icon: Icons.chat_bubble_outline_rounded,
              message: 'No messages yet. Say hello!',
            );
          }
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final m = _messages[index];
              return _MessageBubble(message: m);
            },
          );
        },
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate800),
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Type a message...',
                hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppColors.slate400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: AppColors.slate50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.slate200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.slate200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _isSending ? null : _send,
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: _isSending
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
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
        constraints: const BoxConstraints(maxWidth: 380),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMine ? 12 : 2),
            bottomRight: Radius.circular(isMine ? 2 : 12),
          ),
          border: isMine ? null : Border.all(color: AppColors.slate200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                fontFamily: 'Inter', fontSize: 13,
                color: isMine ? Colors.white : AppColors.slate800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.timeAgo,
              style: TextStyle(
                fontFamily: 'Inter', fontSize: 10,
                color: isMine ? Colors.white70 : AppColors.slate400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}