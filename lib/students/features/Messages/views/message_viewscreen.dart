import 'package:easy_localization/easy_localization.dart';
import 'package:edulink_app/students/features/Messages/cubit/messages_cubit.dart';
import 'package:edulink_app/students/features/Messages/data/messages_repo.dart';
import 'package:edulink_app/students/features/Messages/views/chat_viewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edulink_app/students/shared_widgets/custom_bottom_navigationBar.dart';

/// Students only ever talk to their assigned moderator, so this screen
/// no longer shows a conversation list. It loads the single moderator
/// conversation and opens the chat directly.
class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagesCubit(MessagesRepository())..loadConversations(),
      child: const _MessageView(),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textSecondary = Theme.of(context).colorScheme.onSurfaceVariant;

    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state is MessagesLoading || state is MessagesInitial) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottomNavigationBar: CustomBottomNavigationBar(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              selectedIndex: 2,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MessagesError) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottomNavigationBar: CustomBottomNavigationBar(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              selectedIndex: 2,
            ),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: screenWidth * 0.14,
                          color: textSecondary.withValues(alpha: 0.5)),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: textSecondary),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<MessagesCubit>().loadConversations(),
                        child: Text('Try again'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state is MessagesLoaded) {
          if (state.conversations.isEmpty) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              bottomNavigationBar: CustomBottomNavigationBar(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                selectedIndex: 2,
              ),
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () =>
                      context.read<MessagesCubit>().loadConversations(),
                  child: ListView(
                    children: [
                      SizedBox(height: screenHeight * 0.18),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded,
                                size: screenWidth * 0.15,
                                color: textSecondary.withValues(alpha: 0.4)),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'No messages yet'.tr(),
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1),
                              child: Text(
                                'Your moderator chat will appear here once it\'s ready'
                                    .tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Student only ever has one conversation: their moderator.
          final moderator = state.conversations.first;
          return ChatViewScreen(
            partnerId: moderator.partnerId,
            partnerName: moderator.partnerName,
          );
        }

        return const SizedBox();
      },
    );
  }
}
