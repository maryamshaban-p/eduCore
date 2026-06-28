part of 'session_upload_cubit.dart';

abstract class SessionUploadState {
  const SessionUploadState();
}

class SessionUploadInitial extends SessionUploadState {}

class SessionUploadLoading extends SessionUploadState {}

class SessionUploadUploading extends SessionUploadState {
  final String fileName;
  final int sizeBytes;
  final double progress;
  const SessionUploadUploading({required this.fileName, required this.sizeBytes, required this.progress});
}

class SessionUploadLoaded extends SessionUploadState {
  final HomeworkSubmissionModel? submission;
  const SessionUploadLoaded(this.submission);
}

class SessionUploadError extends SessionUploadState {
  final String message;
  const SessionUploadError(this.message);
}