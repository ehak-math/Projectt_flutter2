import 'package:flutter/material.dart';
import '../core/models/segment_time.dart';
import '../core/services/api_service.dart';

class SegmentTimeProvider with ChangeNotifier {
  List<SegmentTime> _segmentTimes = [];
  bool _isLoading = false;

  List<SegmentTime> get segmentTimes => _segmentTimes;
  bool get isLoading => _isLoading;

  Future<void> fetchSegmentTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/segment-times');
      if (response != null && response['data'] is List) {
        _segmentTimes = (response['data'] as List)
            .map((json) => SegmentTime.fromJson(json))
            .toList();
      } else {
        _segmentTimes = [];
      }
    } catch (e) {
      print('Error fetching segment times: $e');
      _segmentTimes = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> trackSegmentTime({
    required int participantId,
    required int segmentId,
    required DateTime timeRecordedAt,
  }) async {
    try {
      final data = {
        'participant_id': participantId,
        'segment_id': segmentId,
        'time_recorded_at': timeRecordedAt.toIso8601String(),
      };

      final response = await ApiService.post('/track-time', data);

      if (response != null && response['message'] != null) {
        await fetchSegmentTimes(); // Refresh after tracking
      }
    } catch (e) {
      print('Error tracking segment time: $e');
      rethrow;
    }
  }
}
