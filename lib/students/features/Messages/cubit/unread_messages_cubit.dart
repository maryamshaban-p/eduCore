import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/messages_repo.dart';

/// Keeps the unread moderator-message count up to date for the
/// Messages tab badge. Lives at the app root (provided once in
/// main.dart) so the count persists across tab switches.
///
/// Updates happen two ways:
/// - A lightweight periodic poll while the app is active, so a new
///   message shows up even if the student is on another tab.
/// - An immediate `refresh()` call right after leaving the chat
///   screen, so the badge clears instantly once messages are read.
class UnreadMessagesCubit extends Cubit<int> {
  final MessagesRepository _repo;
  Timer? _pollTimer;

  UnreadMessagesCubit(this._repo) : super(0);

  static const _pollInterval = Duration(seconds: 25);

  Future<void> refresh() async {
    try {
      final count = await _repo.getUnreadCount();
      if (!isClosed) emit(count);
    } catch (_) {
      // Silently ignore: a stale badge is preferable to disrupting
      // the user with an error for a non-critical background check.
    }
  }

  void startPolling() {
    refresh();
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) => refresh());
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
