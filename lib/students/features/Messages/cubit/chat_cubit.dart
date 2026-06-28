import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/message_model.dart';
import '../data/messages_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final MessagesRepository _repo;
  final String partnerId;
  List<ChatMessageModel> _messages = [];

  ChatCubit(this._repo, this.partnerId) : super(ChatInitial());

  Future<void> loadHistory() async {
    emit(ChatLoading());
    try {
      _messages = await _repo.getChatHistory(partnerId);
      emit(ChatLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    try {
      final sent = await _repo.sendMessage(partnerId, content.trim());
      _messages = [..._messages, sent];
      emit(ChatLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}