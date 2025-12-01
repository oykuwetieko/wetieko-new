// lib/states/message_access_state_notifier.dart

import 'package:flutter/foundation.dart';
import 'package:Wetieko/data/repositories/message_access_repository.dart';

class MessageAccessStateNotifier extends ChangeNotifier {
  final MessageAccessRepository _repo;

  bool _loading = false;
  bool get loading => _loading;

  List<Map<String, dynamic>> _incoming = [];
  List<Map<String, dynamic>> _outgoing = [];

  List<Map<String, dynamic>> get incoming => _incoming;
  List<Map<String, dynamic>> get outgoing => _outgoing;

  MessageAccessStateNotifier(this._repo);

  void _setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<void> fetchIncoming() async {
    _setLoading(true);
    _incoming = await _repo.getIncomingRequests();
    _setLoading(false);
  }

  Future<void> fetchOutgoing() async {
    _setLoading(true);
    _outgoing = await _repo.getOutgoingRequests();
    _setLoading(false);
  }

  Future<void> accept(String requestId) async {
    await _repo.acceptRequest(requestId);
    await fetchIncoming();
  }

  Future<void> reject(String requestId) async {
    await _repo.rejectRequest(requestId);
    await fetchIncoming();
  }

  Future<void> request(String receiverId) async {
    await _repo.requestAccess(receiverId);
    await fetchOutgoing();
  }

  Future<bool> hasAccess(String receiverId) => _repo.hasAccess(receiverId);
}
