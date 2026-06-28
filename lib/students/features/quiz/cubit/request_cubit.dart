import 'package:flutter_bloc/flutter_bloc.dart';
import 'request_state.dart'; // <-- this was missing
import '../data/request_model.dart';
import '../data/request_repo.dart'; 

class RequestCubit extends Cubit<RequestState> {
  final RequestRepository _repo;

  RequestCubit(this._repo) : super(RequestInitial());

  Future<void> loadMyRequests() async {
    emit(RequestLoading());
    try {
      final requests = await _repo.getMyRequests();
      emit(RequestLoaded(requests));
    } catch (e) {
      emit(RequestError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> submitViewRequest(int sessionId, String reason) async {
    emit(RequestSubmitting());
    try {
      await _repo.submitViewRequest(sessionId, reason);
      emit(RequestSubmitSuccess());
    } catch (e) {
      emit(RequestError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> submitRetakeRequest(int sessionId, String reason) async {
    emit(RequestSubmitting());
    try {
      await _repo.submitRetakeRequest(sessionId, reason);
      emit(RequestSubmitSuccess());
    } catch (e) {
      emit(RequestError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}