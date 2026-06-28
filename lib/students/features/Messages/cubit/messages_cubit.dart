import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/message_model.dart';
import '../data/messages_repo.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final MessagesRepository _repo;

  MessagesCubit(this._repo) : super(MessagesInitial());

  Future<void> loadConversations() async {
    emit(MessagesLoading());
    try {
      final conversations = await _repo.getConversations();
      emit(MessagesLoaded(conversations));
    } catch (e) {
      emit(MessagesError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}