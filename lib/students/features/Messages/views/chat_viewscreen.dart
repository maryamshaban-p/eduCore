import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/Messages/cubit/chat_cubit.dart';
import 'package:edulink_app/students/features/Messages/cubit/unread_messages_cubit.dart';
import 'package:edulink_app/students/features/Messages/data/message_model.dart';
import 'package:edulink_app/students/features/Messages/data/messages_repo.dart';
import 'package:edulink_app/students/features/Messages/widgets/time_ago_formatter.dart';
import 'package:edulink_app/students/features/home/views/home_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatViewScreen extends StatelessWidget {
  final String partnerId;
  final String partnerName;

  const ChatViewScreen({
    super.key,
    required this.partnerId,
    required this.partnerName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ChatCubit(MessagesRepository(), partnerId)..loadHistory(),
      child: _ChatView(partnerName: partnerName),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String partnerName;
  const _ChatView({required this.partnerName});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;
  bool _hasRefreshedUnreadOnLoad = false;

  String _getInitials(String fullName) {
    final parts =
        fullName.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return "?";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSend() async {
    final text = _msgController.text.trim();
    if (text.isEmpty || _isSending) return;
    setState(() => _isSending = true);
    _msgController.clear();
    await context.read<ChatCubit>().sendMessage(text);
    setState(() => _isSending = false);
    _scrollToBottom();
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeViewScreen()),
    );
  }

  @override
  void dispose() {
    // Leaving the chat is when we know any messages just shown have
    // been read, so clear the badge without waiting for the next poll.
    context.read<UnreadMessagesCubit>().refresh();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _goHome,
        ),

        title: Row(
          children: [
            SizedBox(width: screenWidth * 0.02),
            CircleAvatar(
              radius: screenWidth * 0.05,
              backgroundColor: const Color(0xFFE6F1FB),
              child: Text(
                _getInitials(widget.partnerName),
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF185FA5),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.partnerName,
                  style: TextStyle(
                    fontSize: screenWidth * 0.042,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
                Text(
                  'Moderator'.tr(),
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatLoaded) {
                    _scrollToBottom();
                    if (!_hasRefreshedUnreadOnLoad) {
                      _hasRefreshedUnreadOnLoad = true;
                      context.read<UnreadMessagesCubit>().refresh();
                    }
                  }
                  if (state is ChatError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading || state is ChatInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatError) {
                    return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center),
                    );
                  }

                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.waving_hand_outlined,
                                size: screenWidth * 0.12,
                                color: textSecondary.withValues(alpha: 0.4)),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              'Say hi to ${widget.partnerName}'.tr(),
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: textSecondary),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final prev = index > 0 ? state.messages[index - 1] : null;
                        final showDate = prev == null ||
                            !_sameDay(msg.sentAt, prev.sentAt);

                        return Column(
                          children: [
                            if (showDate) _DateDivider(
                              date: msg.sentAt,
                              screenWidth: screenWidth,
                            ),
                            ChatBubble(
                              message: msg,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                          ],
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),

            // Input Bar
            _MessageInputBar(
              controller: _msgController,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isSending: _isSending,
              onSend: _handleSend,
            ),
          ],
        ),
      ),
    );
  }

  bool _sameDay(String a, String b) {
    try {
      final da = DateTime.parse(a);
      final db = DateTime.parse(b);
      return da.year == db.year && da.month == db.month && da.day == db.day;
    } catch (_) {
      return true;
    }
  }
}

class _DateDivider extends StatelessWidget {
  final String date;
  final double screenWidth;

  const _DateDivider({required this.date, required this.screenWidth});

  String _formatDate(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      if (d.year == now.year && d.month == now.month && d.day == now.day)
        return 'Today';
      final yesterday = now.subtract(const Duration(days: 1));
      if (d.year == yesterday.year &&
          d.month == yesterday.month &&
          d.day == yesterday.day) return 'Yesterday';
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: Theme.of(context).dividerColor)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: screenWidth * 0.029,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Theme.of(context).dividerColor)),
        ],
      ),
    );
  }
}


class ChatBubble extends StatefulWidget {
  final ChatMessageModel message;
  final double screenWidth;
  final double screenHeight;
  final bool isLast;

  const ChatBubble({
    super.key,
    required this.message,
    required this.screenWidth,
    required this.screenHeight,
    this.isLast = false,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 250));

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMine = widget.message.isMine;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: widget.screenHeight * 0.002,
                ),
                constraints: BoxConstraints(
                  maxWidth: widget.screenWidth * 0.75,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: widget.screenWidth * 0.04,
                  vertical: widget.screenHeight * 0.012,
                ),
                decoration: BoxDecoration(
                  color: isMine
                      ? const Color(0xFF378ADD)
                      : Theme.of(context).cardColor,
                  border: isMine
                      ? null
                      : Border.all(
                          color: Theme.of(context).dividerColor.withOpacity(0.4),
                          width: 0.6,
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14),
                    bottomLeft: Radius.circular(isMine ? 14 : 4),
                    bottomRight: Radius.circular(isMine ? 4 : 14),
                  ),
                ),
                child: Text(
                  widget.message.content,
                  style: TextStyle(
                    fontSize: widget.screenWidth * 0.038,
                    color: isMine ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.015),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatMessageTime(widget.message.sentAt),
                      style: TextStyle(
                        fontSize: widget.screenWidth * 0.027,
                        color: textSecondary,
                      ),
                    ),
                    if (isMine) ...[
                      SizedBox(width: 3),
                      Icon(
                        widget.message.isRead
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: widget.screenWidth * 0.032,
                        color: widget.message.isRead
                            ? const Color(0xFF378ADD)
                            : textSecondary,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: widget.screenHeight * 0.008),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final double screenWidth;
  final double screenHeight;
  final bool isSending;
  final VoidCallback onSend;

  const _MessageInputBar({
    required this.controller,
    required this.screenWidth,
    required this.screenHeight,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.012,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.07),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: Theme.of(context).colorScheme.onSurface),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: 'Type a message...'.tr(),
                  hintStyle: TextStyle(
                    fontSize: screenWidth * 0.036,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Color(0xFF378ADD),
                      width: 1,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.045,
                    vertical: screenHeight * 0.012,
                  ),
                  isCollapsed: false,
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.025),
          GestureDetector(
            onTap: onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: screenWidth * 0.11,
              height: screenWidth * 0.11,
              decoration: BoxDecoration(
                color: isSending
                    ? const Color(0xFF378ADD).withValues(alpha: 0.6)
                    : const Color(0xFF378ADD),
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? Padding(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      child: const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Icon(Icons.arrow_upward_rounded,
                      color: Colors.white, size: screenWidth * 0.05),
            ),
          ),
        ],
      ),
    );
  }
}
