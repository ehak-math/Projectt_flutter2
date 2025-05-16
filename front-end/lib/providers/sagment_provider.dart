import 'package:flutter/material.dart';
import '../core/models/sagment.dart';
import '../core/services/api_service.dart';

class SegmentProvider with ChangeNotifier {
  List<Segment> _segments = [];
  bool _isLoading = false;
  int? _currentRaceId; // 👈 store last-used race ID

  List<Segment> get segments => _segments;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fetch segments for a specific race
  Future<void> fetchSegments(int raceId) async {
    try {
      _setLoading(true);
      _currentRaceId = raceId;
      final response = await ApiService.get('/races/$raceId/segments');
      final data = response['data'] as List;
      _segments = data.map((e) => Segment.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching segments: $e");
      // Show an error message or handle the state accordingly
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

   Future<void> fetchSegmentsTracker(int raceId) async {
    try {
      _setLoading(true);
      _currentRaceId = raceId;
      final response = await ApiService.get('/races/$raceId/segment-tracker');
      final data = response['data'] as List;
      _segments = data.map((e) => Segment.fromJson(e)).toList();
    } catch (e) {
      print("Error fetching segments: $e");
      // Show an error message or handle the state accordingly
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Add segment, then re-fetch using stored raceId
  Future<void> addSegment(Map<String, dynamic> body) async {
    try {
      await ApiService.post('/segments', body);
      if (_currentRaceId != null) {
        await fetchSegments(_currentRaceId!);
      }
    } catch (e) {
      print("Error adding segment: $e");
    }
  }

  // Delete and refresh
  Future<void> deleteSegment(int id) async {
    try {
      await ApiService.delete('/segments/$id');
      _segments.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print("Error deleting segment: $e");
    }
  }

  // Update and refresh
  Future<void> updateSegment(int id, Map<String, dynamic> body) async {
    try {
      await ApiService.put('/segments/$id', body);
      if (_currentRaceId != null) {
        await fetchSegments(_currentRaceId!);
      }
    } catch (e) {
      print("Error updating segment: $e");
    }
  }
}
