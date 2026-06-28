import 'package:edulink_app/students/features/session/data/session_model.dart';
import 'package:edulink_app/students/features/session/data/session_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_upload_state.dart';

class SessionUploadCubit extends Cubit<SessionUploadState> {
  final SessionRepository _repo;
  final int sessionId;

  SessionUploadCubit(this._repo, this.sessionId) : super(SessionUploadInitial());

  Future<void> loadHomeworkStatus() async {
    emit(SessionUploadLoading());
    try {
      final submission = await _repo.getHomeworkSubmission(sessionId);
      emit(SessionUploadLoaded(submission));
    } catch (e) {
      emit(SessionUploadError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> pickAndSubmitHomework() async {
    final result = await FilePicker.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return;

    final pickedFile = result.files.first;
    final bytes = pickedFile.bytes;
    if (bytes == null) {
      emit(SessionUploadError('Could not read file.'));
      return;
    }

    emit(SessionUploadUploading(fileName: pickedFile.name, sizeBytes: pickedFile.size, progress: 0.0));

    try {
      final storagePath =
          'homework_submissions/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final refStorage = FirebaseStorage.instance.ref(storagePath);

      final uploadTask = refStorage.putData(bytes);
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        emit(SessionUploadUploading(fileName: pickedFile.name, sizeBytes: pickedFile.size, progress: progress));
      });

      await uploadTask;
      final fileUrl = await refStorage.getDownloadURL();

      await _repo.submitHomework(
        sessionId: sessionId,
        fileName: pickedFile.name,
        fileUrl: fileUrl,
        fileSizeBytes: pickedFile.size,
      );

      await loadHomeworkStatus();
    } catch (e) {
      emit(SessionUploadError('Failed to upload: $e'));
    }
  }
}