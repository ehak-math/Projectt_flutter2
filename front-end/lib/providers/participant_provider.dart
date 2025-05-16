import 'package:flutter/material.dart';
import '../core/models/participant.dart';
import '../core/services/api_service.dart';

class ParticipantProvider with ChangeNotifier {
  List<Participant> _participants = [];
  bool _isLoading = false;
  Participant? _selectedParticipant;

  List<Participant> get participants => _participants;
  bool get isLoading => _isLoading;
  Participant? get selectedParticipant => _selectedParticipant;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ✅ Fetch participants filtered by race
  Future<void> fetchParticipants(int raceId) async {
    try {
      _setLoading(true);
      final response = await ApiService.get('/races/$raceId/participants');

      final dataList = response['data'] as List;
      //  print('Fetched participants: ${response.body}'); // ✅ Debug line
      _participants =
          dataList
              .where((e) => e != null)
              .map((e) => Participant.fromJson(e))
              .toList();
    } catch (e) {
      print("Error fetching participants for race $raceId: $e");
    } finally {
      _setLoading(false);
    }
  }

    Future<void> fetchParticipantsTracker(int raceId) async {
    try {
      _setLoading(true);
      final response = await ApiService.get('/races/$raceId/participant-trackers');

      final dataList = response['data'] as List;
      //  print('Fetched participants: ${response.body}'); // ✅ Debug line
      _participants =
          dataList
              .where((e) => e != null)
              .map((e) => Participant.fromJson(e))
              .toList();
    } catch (e) {
      print("Error fetching participants for race $raceId: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllParticipants() async {
    try {
      _setLoading(true);
      final response = await ApiService.get('/participants');

      final dataList = response['data'] as List;
      _participants = dataList.map((e) => Participant.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching all participants: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addParticipant(Map<String, dynamic> body, int raceId) async {
    try {
      await ApiService.post('/participants', body);
      await fetchParticipants(raceId);
    } catch (e) {
      print("Error adding participant: $e");
    }
  }

  Future<void> deleteParticipant(int id, int raceId) async {
    try {
      await ApiService.delete('/participants/$id');
      _participants.removeWhere((p) => p.id == id);
      notifyListeners();
      await fetchParticipants(raceId);
    } catch (e) {
      print("Error deleting participant: $e");
    }
  }

  Future<void> updateParticipant(
    int id,
    Map<String, dynamic> body,
    int raceId,
  ) async {
    try {
      await ApiService.put('/participants/$id', body);
      await fetchParticipants(raceId);
    } catch (e) {
      print("Error updating participant: $e");
    }
  }

  Future<void> selectParticipant(int id) async {
    try {
      _setLoading(true);
      final data = await ApiService.get('/participants/$id');
      _selectedParticipant = Participant.fromJson(data);
      notifyListeners();
    } catch (e) {
      print("Error fetching participant by ID: $e");
    } finally {
      _setLoading(false);
    }
  }

  void clearSelectedParticipant() {
    _selectedParticipant = null;
    notifyListeners();
  }
}
