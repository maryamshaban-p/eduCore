part of 'chat_cubit.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  const ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}