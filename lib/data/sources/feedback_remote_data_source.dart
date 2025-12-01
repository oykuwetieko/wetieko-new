import 'dart:io';
import 'package:Wetieko/core/services/api_service.dart';
import 'package:Wetieko/models/feedback_model.dart';

class FeedbackRemoteDataSource {
  final ApiService api;

  FeedbackRemoteDataSource(this.api);

  // 🔥 LOG HELPERS
  void _log(String title, dynamic data) {
    print('''
────────────────────────────────────────
📌 $title
────────────────────────────────────────
$data
────────────────────────────────────────
''');
  }

  void _error(String title, dynamic e) {
    print('''
❌ ERROR → $title
────────────────────────────────────────
$e
────────────────────────────────────────
''');
  }

  // ⭐ FEEDBACK SUBMIT
  Future<void> submitFeedback(FeedbackDto dto) async {
    try {
      _log("📨 SUBMIT FEEDBACK", dto.toJson());

      final response = await api.post('/api/places/feedback', dto.toJson());

     
    } catch (e) {
      _error("submitFeedback()", e);
      rethrow;
    }
  }

  // ⭐ FEEDBACK PHOTO UPLOAD
  Future<String> uploadFeedbackPhoto(File file) async {
    try {
      final fileName = file.path.split('/').last;

      _log("📤 UPLOAD FEEDBACK PHOTO → $fileName", "");

      final formData = {
        'file': await api.multipartFile(file),
      };

      final response =
          await api.postMultipart('/api/uploads/feedback', formData);

      

      final url = response.data['data']?['url'];

      if (url == null) throw Exception("Upload response contains no URL");

      return url;
    } catch (e) {
      _error("uploadFeedbackPhoto()", e);
      rethrow;
    }
  }

  // ⭐ GET FEEDBACK BY PLACE
  Future<List<PlaceFeedback>> getFeedbacksByPlace(String placeId) async {
    try {
      final response =
          await api.get('/api/places/feedback/by-place/$placeId');

      final raw = response.data;

      if (raw == null || raw is! Map) return [];

      final data = raw['data'];

      if (data == null || data is! List) return [];

      return data
          .map((e) => PlaceFeedback.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error("getFeedbacksByPlace()", e);
      rethrow;
    }
  }

  // ⭐ GET MY FEEDBACKS
  Future<List<PlaceFeedback>> getMyFeedbacks() async {
    try {
      final response = await api.get('/api/places/feedback/by-user/me');

      final raw = response.data;

      if (raw is! Map<String, dynamic>) return [];

      final data = raw['data'];
      if (data is! Map<String, dynamic>) return [];

      final list = data['feedbacks'];
      if (list is! List) return [];

      return list
          .map((e) => PlaceFeedback.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error("getMyFeedbacks()", e);
      rethrow;
    }
  }

  // ⭐ DELETE FEEDBACK (POST)
  Future<void> deleteFeedback(String feedbackId) async {
    try {
      _log("🗑 DELETE FEEDBACK REQUEST → $feedbackId", "");

      final response =
          await api.post('/api/places/feedback/delete/$feedbackId', {});

    
    } catch (e) {
      _error("deleteFeedback()", e);
      rethrow;
    }
  }

  // ⭐ GET FEEDBACK BY USER
  Future<List<PlaceFeedback>> getFeedbacksByUserId(String userId) async {
    try {
      final response =
          await api.get('/api/places/feedback/by-user/$userId');

      final data = response.data;

      final feedbackList = data is Map<String, dynamic>
          ? (data['feedbacks'] ?? []) as List
          : [];

      return feedbackList
          .map((e) => PlaceFeedback.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _error("getFeedbacksByUserId()", e);
      rethrow;
    }
  }
}
