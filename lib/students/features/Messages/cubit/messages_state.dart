part of 'messages_cubit.dart';

abstract class MessagesState {
  const MessagesState();
}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<ConversationModel> conversations;
  const MessagesLoaded(this.conversations);
}

class MessagesError extends MessagesState {
  final String message;
  const MessagesError(this.message);
}