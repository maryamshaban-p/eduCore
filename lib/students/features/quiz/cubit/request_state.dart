// lib/students/features/requests/cubit/request_state.dart


import 'package:edulink_app/students/features/quiz/data/request_model.dart';

abstract class RequestState {}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestLoaded extends RequestState {
  final List<StudentRequest> requests;
  RequestLoaded(this.requests);
}

class RequestSubmitting extends RequestState {}

class RequestSubmitSuccess extends RequestState {}

class RequestError extends RequestState {
  final String message;
  RequestError(this.message);
}