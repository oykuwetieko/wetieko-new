import 'dart:io';
import 'package:Wetieko/data/sources/feedback_remote_data_source.dart';
import 'package:Wetieko/models/feedback_model.dart';

class FeedbackRepository {
  final FeedbackRemoteDataSource remote;

  FeedbackRepository(this.remote);

  /// Feedback gönderme (DTO dışarıda hazırlanır)
  Future<void> submitFeedback(FeedbackDto dto) {
    return remote.submitFeedback(dto);
  }

  /// Feedback fotoğraf yükleme
  Future<String> uploadFeedbackPhoto(File photoFile) {
    return remote.uploadFeedbackPhoto(photoFile);
  }

  Future<List<PlaceFeedback>> getFeedbacksByPlace(String placeId) {
    return remote.getFeedbacksByPlace(placeId);
  }

  Future<List<PlaceFeedback>> getMyFeedbacks() {
    return remote.getMyFeedbacks();
  }

  Future<void> deleteFeedback(String feedbackId) {
    return remote.deleteFeedback(feedbackId);
  }

  Future<List<PlaceFeedback>> getFeedbacksByUserId(String userId) {
    return remote.getFeedbacksByUserId(userId);
  }
}
