import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../core/models/race.dart';

class RaceProvider with ChangeNotifier {
  List<Race> _races = [];
  String _raceName = '';
  bool _isLoading = false;

  List<Race> get races => _races;
  String get raceName => _raceName;
  bool get isLoading => _isLoading;

  // Fetch all races
  Future<void> fetchRaces() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/races');

      if (response != null && response['data'] is List) {
        _races =
            (response['data'] as List)
                .map((json) => Race.fromJson(json))
                .toList();
      } else {
        _races = [];
      }
    } catch (error) {
      print('Error fetching races: $error');
      _races = [];
    }

    _isLoading = false;
    notifyListeners();
  }

    Future<void> fetchRacesTracker() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/races-tracker');

      if (response != null && response['data'] is List) {
        _races =
            (response['data'] as List)
                .map((json) => Race.fromJson(json))
                .toList();
      } else {
        _races = [];
      }
    } catch (error) {
      print('Error fetching races: $error');
      _races = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch single race name
  Future<void> fetchRaceName(int raceId) async {
    try {
      final response = await ApiService.get('/races/$raceId');
      if (response != null && response['data'] != null) {
        _raceName = response['data']['name'];
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching race name: $e');
    }
  }

  // Get a specific race by raceId
  Race? getRaceById(int raceId) {
    try {
      return _races.firstWhere((race) => race.id == raceId);
    } catch (e) {
      return null; // Return null if no race is found
    }
  }

  // Start race
  Future<void> startRace(int raceId) async {
    try {
      final response = await ApiService.post('/races/$raceId/start', {});
      if (response != null) await fetchRaces();
    } catch (error) {
      print('Error starting race: $error');
      rethrow;
    }
  }

  // Finish race
  Future<void> finishRace(int raceId) async {
    try {
      final response = await ApiService.post('/races/$raceId/finish', {});
      if (response != null) await fetchRaces();
    } catch (error) {
      print('Error finishing race: $error');
      rethrow;
    }
  }

  // Reset race
  Future<void> resetRace(int raceId) async {
    try {
      final response = await ApiService.post('/races/$raceId/reset', {});
      if (response != null) await fetchRaces();
    } catch (error) {
      print('Error resetting race: $error');
      rethrow;
    }
  }

  // Create race
  Future<void> createRace(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('/races', data);
      if (response != null) await fetchRaces();
    } catch (error) {
      print('Error creating race: $error');
      rethrow;
    }
  }
}
