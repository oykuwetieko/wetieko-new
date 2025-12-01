// lib/data/repositories/message_access_repository.dart

import 'package:Wetieko/data/sources/message_access_remote_data_source.dart';

class MessageAccessRepository {
  final MessageAccessRemoteDataSource remote;

  MessageAccessRepository(this.remote);

  Future<void> requestAccess(String receiverId) => remote.requestAccess(receiverId);
  Future<void> acceptRequest(String requestId) => remote.acceptRequest(requestId);
  Future<void> rejectRequest(String requestId) => remote.rejectRequest(requestId);
  Future<List<Map<String, dynamic>>> getIncomingRequests() => remote.getIncomingRequests();
  Future<List<Map<String, dynamic>>> getOutgoingRequests() => remote.getOutgoingRequests();
  Future<bool> hasAccess(String receiverId) => remote.hasAccess(receiverId);
  Future<List<Map<String, dynamic>>> getAccessList() => remote.getAccessList();
}
